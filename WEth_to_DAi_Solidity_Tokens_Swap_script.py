import json
from web3 import Web3
from web3.exceptions import ContractLogicError
from solcx import install_solc, compile_source

install_solc(version="latest")

# Set Geth's URL
GETH_URL = "http://localhost:8545"

w3 = Web3(Web3.HTTPProvider(GETH_URL))
dev_account_address = w3.eth.accounts[0]
w3.eth.default_account = dev_account_address


def compile_contract(filename):
    with open(filename, "r") as file:
        contract_source = file.read().strip()
    compiled_sol = compile_source(
        contract_source, output_values=["abi", "bin"], optimize=True
    )
    print(f"Compilation units: {len(compiled_sol)}")
    return compiled_sol


def main():
    print(f"Starting block number: {w3.eth.block_number}")

    # Compile our Uniswap contract
    compiled_sol = compile_contract("test/examples/swaps/UniswapV2SwapRenamed.sol")

    # List of contracts to deploy (in this order)
    contract_ids = [
        "uniswapV2Pair",
        "uniswapV2Router02",
        "uniswapV2Swap",
        "uniswapV2SwapTest",
    ]
    
    solidity_usdc_hex = open('test/demo-contracts/UniswapV2SwapRenamed.USDC.kore.bin').read().rstrip()
    solidity_dai_hex = open('test/demo-contracts/UniswapV2SwapRenamed.DAI.kore.bin').read().rstrip()
    solidity_weth_hex = open('test/demo-contracts/UniswapV2SwapRenamed.WETH.kore.bin').read().rstrip()
    
    solidity_contracts = {"uSDCMock": solidity_usdc_hex, "dAIMock": solidity_dai_hex, "wETHMock": solidity_weth_hex}
    solidity_contracts_address = {}
    
    for sol_contract_name, sol_contract_hex in solidity_contracts.items():
        deploy_solidity_tx = {
            'from': dev_account_address,
            'data': sol_contract_hex,
            'to': '',
            'value': 0,
            'gas': 11000000,
            'maxFeePerGas': 2000000000,
            'maxPriorityFeePerGas': 1000000000,
        }
    
        tx_hash = w3.eth.send_transaction(deploy_solidity_tx)
        receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
        solidity_contracts_address[sol_contract_name] = receipt['contractAddress']
        print(f"Contract {sol_contract_name} deployed with address: {receipt['contractAddress']}")
        

    # Deploy contracts
    deployed_contracts = {}
    for id in contract_ids:
        interface = compiled_sol["<stdin>:" + id]
        abi, binary = interface["abi"], interface["bin"]
        Contract = w3.eth.contract(abi=abi, bytecode="6B65766D" + binary)
        if id in {"uniswapV2Swap", "uniswapV2Pair"}:
            # We know by now token contracts were already deployed
            weth_address = solidity_contracts_address["wETHMock"]
            dai_address = solidity_contracts_address["dAIMock"]
            usdc_address = solidity_contracts_address["uSDCMock"]
            if id == "uniswapV2Swap":
                tx_hash = Contract.constructor(
                    weth_address, dai_address, usdc_address
                ).transact()
                tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
                deployed_contracts[id] = {
                    "address": tx_receipt.contractAddress,
                    "abi": abi,
                }
                print(
                    f"Contract {id} deployed with address: {tx_receipt.contractAddress}"
                )
            elif id == "uniswapV2Pair":
                # Deploy (weth, dai)
                tx_hash = Contract.constructor(weth_address, dai_address).transact()
                tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
                deployed_contracts[id + ":WETH-DAI"] = {
                    "address": tx_receipt.contractAddress,
                    "abi": abi,
                }
                print(
                    f"Contract {id}:WETH-DAI deployed with address: {tx_receipt.contractAddress}"
                )

                # Deploy (weth, usdc)
                tx_hash = Contract.constructor(weth_address, usdc_address).transact()
                tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
                deployed_contracts[id + ":WETH-USDC"] = {
                    "address": tx_receipt.contractAddress,
                    "abi": abi,
                }
                print(
                    f"Contract {id}:WETH-USDC deployed with address: {tx_receipt.contractAddress}"
                )

                # Deploy (usdc, dai)
                tx_hash = Contract.constructor(usdc_address, dai_address).transact()
                tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
                deployed_contracts[id + ":USDC-DAI"] = {
                    "address": tx_receipt.contractAddress,
                    "abi": abi,
                }
                print(
                    f"Contract {id}:USDC-DAI deployed with address: {tx_receipt.contractAddress}"
                )
        else:
            # Token, router or test contracts
            tx_hash = Contract.constructor().transact()
            tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
            deployed_contracts[id] = {"address": tx_receipt.contractAddress, "abi": abi}
            print(f"Contract {id} deployed with address: {tx_receipt.contractAddress}")

    # Mint tokens to dev account
    weth_address = solidity_contracts_address["wETHMock"]
    dai_address = solidity_contracts_address["dAIMock"]
    #usdc_address = solidity_contracts_address["uSDCMock"]

    # Mint WETH (Deposit, as WETH doesn't have mint function)
    deposit_weth_data = 'd0e30db0'
    deposit_weth_tx = {
        "chainId": w3.eth.chain_id,
        "from": dev_account_address,
        'data': deposit_weth_data,
        'to': weth_address,
        "value": w3.to_wei(10000000, "ether"),
        "gas": 200000,
        "gasPrice": w3.to_wei(20, "gwei"),
        "nonce": w3.eth.get_transaction_count(dev_account_address),
    }
    tx_hash = w3.eth.send_transaction(deposit_weth_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Minted WETH: ", tx_receipt["status"] == 1 and "Success" or "Failed")

    # Mint DAI
    # mint(dev_account_address, 10000000 * 10**18)
    dai_mint_data = '40c10f19000000000000000000000000' + dev_account_address[2:] + '000000000000000000000000000000000000000000084595161401484a000000'
    mint_dai_tx = {
        'from': dev_account_address,
        'data': dai_mint_data,
        'to': dai_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }
    
    tx_hash = w3.eth.send_transaction(mint_dai_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Minted DAI: ", tx_receipt["status"] == 1 and "Success" or "Failed")

    # Approve the router to spend tokens
    router_address = deployed_contracts["uniswapV2Router02"]["address"]
    
    # Approve WETH mint transaction
    # approve(router_address, 10000000 * 10**18)
    weth_approve_data = '086c40f6000000000000000000000000' + router_address[2:] + '000000000000000000000000000000000000000000084595161401484a000000'
    weth_approve_tx = {
        'from': dev_account_address,
        'data': weth_approve_data,
        'to': weth_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }

    tx_hash = w3.eth.send_transaction(weth_approve_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Approved WETH: ", tx_receipt["status"] == 1 and "Success" or "Failed")
    
    # Approve DAI mint transaction
    # approve(router_address, 10000000 * 10**18)
    dai_approve_data = '086c40f6000000000000000000000000' + router_address[2:] + '000000000000000000000000000000000000000000084595161401484a000000'
    dai_approve_tx = {
        'from': dev_account_address,
        'data': dai_approve_data,
        'to': dai_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }
    
    tx_hash = w3.eth.send_transaction(dai_approve_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Approved DAI: ", tx_receipt["status"] == 1 and "Success" or "Failed")

    # Add liquidity to pools
    router_abi = deployed_contracts["uniswapV2Router02"]["abi"]
    router = w3.eth.contract(address=router_address, abi=router_abi)

    # Add liquidity to (WETH, DAI)
    tx_hash = router.functions.addLiquidity(
        weth_address,
        dai_address,
        200 * 10**18,
        500000 * 10**18,
        0,
        0,
        dev_account_address,
    ).transact(
        {
            "from": dev_account_address,
            "gas": 3000000,
            "gasPrice": Web3.to_wei("20", "gwei"),
        }
    )
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Added liquidity to WETH-DAI")

    # Perform a single-hop swap (WETH to DAI)
    swap_meta = deployed_contracts["uniswapV2Swap"]
    swap_address, swap_abi = swap_meta["address"], swap_meta["abi"]
    swap = w3.eth.contract(address=swap_address, abi=swap_abi)

    tx_hash = swap.functions.swapSingleHopExactAmountIn(
        1 * 10**18,
        2500 * 10**18,
    ).transact(
        {
            "from": dev_account_address,
            "gas": 3000000,
            "gasPrice": Web3.to_wei("20", "gwei"),
        }
    )
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Swapped WETH to DAI")


if __name__ == "__main__":
    main()
