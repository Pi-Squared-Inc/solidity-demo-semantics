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
print(f"Dev account address: {dev_account_address}")

BALANCES=True
RECEIPTS=False

def compile_contract(filename):
    with open(filename, "r") as file:
        contract_source = file.read().strip()
    compiled_sol = compile_source(
        contract_source, output_values=["abi", "bin"], optimize=True
    )
    print(f"Compilation units: {len(compiled_sol)}")
    print("")
    return compiled_sol

def balanceOf(contract_name, token_address, owner_Address):
    balanceOf_data = '70a08231000000000000000000000000' + owner_Address[2:]

    balanceOf_tx = {
        'from': owner_Address,
        'data': balanceOf_data,
        'to': token_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }

    balance = w3.eth.call(balanceOf_tx)
    print(f' > Balance of {contract_name}: {int(balance.hex(), 16)}')

def deploy_tokens(owner_address):
    solidity_usdc_hex = open('test/demo-contracts/UniswapV2SwapRenamed.USDC.kore.bin').read().rstrip()
    solidity_dai_hex = open('/home/robertorosmaninho/pi2-inc/rust-demo-semantics/.build/erc20/rust-token.bin').read().rstrip()
    solidity_weth_hex = open('test/demo-contracts/UniswapV2SwapRenamed.WETH.kore.bin').read().rstrip()

    solidity_contracts = {"uSDCMock": solidity_usdc_hex, "dAIMock": solidity_dai_hex, "wETHMock": solidity_weth_hex}
    solidity_contracts_address = {}

    for sol_contract_name, sol_contract_hex in solidity_contracts.items():
        deploy_solidity_tx = {
            'from': owner_address,
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
        print(f"Contract {sol_contract_name} deployed with address: {solidity_contracts_address[sol_contract_name]}")

        if RECEIPTS:
            print(receipt)

        if BALANCES:
            balanceOf(sol_contract_name, solidity_contracts_address[sol_contract_name], owner_address)

    return solidity_contracts_address

def deploy_contracts(compiled_sol, contract_ids, solidity_contracts_address):
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

    return deployed_contracts

def deposit_weth(owner_Address, weth_address, amount):
    deposit_weth_data = 'd0e30db0'
    deposit_weth_tx = {
        "chainId": w3.eth.chain_id,
        "from": owner_Address,
        'data': deposit_weth_data,
        'to': weth_address,
        "value": amount,
        "gas": 200000,
        "gasPrice": w3.to_wei(20, "gwei"),
        "nonce": w3.eth.get_transaction_count(dev_account_address),
    }
    tx_hash = w3.eth.send_transaction(deposit_weth_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Deposited WETH:", tx_receipt["status"] == 1 and "Success" or "Failed")

    if RECEIPTS:
        print(tx_receipt)

    if BALANCES:
        balanceOf("WETH", weth_address, dev_account_address)

def mint_token(token_name, token_address, owner_Address, amount):
    token_mint_data = '40c10f19000000000000000000000000' + owner_Address[2:] + amount
    mint_token_tx = {
        'from': owner_Address,
        'data': token_mint_data,
        'to': token_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }

    tx_hash = w3.eth.send_transaction(mint_token_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Minted " + token_name + ":", tx_receipt["status"] == 1 and "Success" or "Failed")

    if RECEIPTS:
        print(tx_receipt)

    if BALANCES:
        balanceOf(token_name, token_address, owner_Address)

def approve(token_name, token_address, owner_address, spender_address, amount):
    token_approve_data = '095ea7b3000000000000000000000000' + spender_address[2:] + amount
    token_approve_tx = {
        'from': owner_address,
        'data': token_approve_data,
        'to': token_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }

    tx_hash = w3.eth.send_transaction(token_approve_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Approved " + token_name + ":", tx_receipt["status"] == 1 and "Success" or "Failed")
    if RECEIPTS:
        print(tx_receipt)

def allowance(token_name, token_address, owner_address, spender_address):
    token_allowance_data = 'dd62ed3e000000000000000000000000' + owner_address[2:] + '000000000000000000000000' + spender_address[2:]
    token_allowance_tx = {
        'from': owner_address,
        'data': token_allowance_data,
        'to': token_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }

    allowance = w3.eth.call(token_allowance_tx)
    print(f' > Allowance of {token_name}: {int(allowance.hex(), 16)}')

def transfer(token_name, token_address, owner_address, to_name, to_address, amount):
    token_transfer_data = 'a9059cbb000000000000000000000000' + to_address[2:] + amount
    token_transfer_tx = {
        'from': owner_address,
        'data': token_transfer_data,
        'to': token_address,
        'value': 0,
        'gas': 11000000,
        'maxFeePerGas': 2000000000,
        'maxPriorityFeePerGas': 1000000000,
    }
    tx_hash = w3.eth.send_transaction(token_transfer_tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Transferred", token_name, "to", to_name + ":", tx_receipt["status"] == 1 and "Success" or "Failed")
    if RECEIPTS:
        print(tx_receipt)



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

    # Deploy tokens
    solidity_contracts_address = deploy_tokens(dev_account_address)

    # Deploy contracts
    print("")
    deployed_contracts = deploy_contracts(compiled_sol, contract_ids, solidity_contracts_address)

    # Instantiate Uniswap contracts
    swap_meta = deployed_contracts["uniswapV2Swap"]
    swap_address, swap_abi = swap_meta["address"], swap_meta["abi"]
    swap = w3.eth.contract(address=swap_address, abi=swap_abi)

    router_abi = deployed_contracts["uniswapV2Router02"]["abi"]
    router_address = swap.functions.router().call()
    router = w3.eth.contract(address=router_address, abi=router_abi)

    # 10000000 * 10**18 = '000000000000000000000000000000000000000000084595161401484a000000'
    eth_10000000_hex = "{:064x}".format(10**10)
    eth_10000000 = 10**10 #w3.to_wei(10000000, "ether")

    # Mint tokens to dev account
    weth_address = solidity_contracts_address["wETHMock"]
    dai_address = solidity_contracts_address["dAIMock"]
    usdc_address = solidity_contracts_address["uSDCMock"]

    # WETH
    print("")
    print("WETH")

    # Mint WETH (Deposit, as WETH doesn't have mint function)
    deposit_weth(dev_account_address, weth_address, eth_10000000)

    # approve(router_address, 10000000 * 10**18)
    approve("WETH", weth_address, dev_account_address, router_address, eth_10000000_hex)

    #call allowance
    allowance("WETH", weth_address, dev_account_address, router_address)

    # USDC
    print("")
    print("USDC")

    # Mint USDC
    # mint(dev_account_address, 10000000 * 10**18)
    mint_token("USDC", usdc_address, dev_account_address, eth_10000000_hex)

    # Approve USDC mint transaction
    # approve(router_address, 10000000 * 10**18)
    approve("USDC", usdc_address, dev_account_address, router_address, eth_10000000_hex)

    #call allowance
    allowance("USDC", usdc_address, dev_account_address, router_address)

    # DAI
    print("")
    print("DAI")

    # Mint DAI
    # mint(dev_account_address, 10000000 * 10**18)
    mint_token("DAI", dai_address, dev_account_address, eth_10000000_hex)

    # Approve DAI mint transaction
    # approve(router_address, 10000000 * 10**18)
    approve("DAI", dai_address, dev_account_address, router_address, eth_10000000_hex)

    # call allowance
    allowance("DAI", dai_address, dev_account_address, router_address)


    print("")
    print("TESTS")

    # Add liquidity to (WETH, DAI)
    tx_hash = router.functions.addLiquidity(
        weth_address,
        dai_address,
        2 * 10**5,
        50 * 10**5,
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
    print("Added liquidity to WETH-DAI: ", tx_receipt["status"] == 1 and "Success" or "Failed")
    if RECEIPTS:
        print(tx_receipt)

    ######################################### SwapSingleHopExactAmountIn Test ##########################################
    print("")
    print("Starting SwapSingleHopExactAmountIn Test...")
    
    weth_amount = 1 * 5**10
    weth_amount_hex = "{:064x}".format(weth_amount)
    two_weth_amount = 2 * weth_amount
    two_weth_amount_hex = "{:064x}".format(two_weth_amount)
    dai_amount_min = 1

    # Approve WETH transaction to uniswapV2Swap contract
    # approve(swap_address, two_weth_amount_hex)
    approve("WETH", weth_address, dev_account_address, swap_address, two_weth_amount_hex)

    # Approve DAI transaction to uniswapV2Swap contract
    # approve(swap_address, weth_amount_hex)
    approve("DAI", dai_address, dev_account_address, swap_address, weth_amount_hex)

    # Get local pair address for WETH-DAI so we can transfer WETH and DAI to it
    address_local_pair_weth_dai = router.functions.getLocalPair(weth_address, dai_address).call()

    # WETH transfer to address_local_pair_weth_dai
    transfer("WETH", weth_address, dev_account_address, "Local Pair WETH-DAI", address_local_pair_weth_dai, two_weth_amount_hex)

    # DAI transfer to address_local_pair_weth_dai
    transfer("DAI", dai_address, dev_account_address, "Local Pair WETH-DAI", address_local_pair_weth_dai, weth_amount_hex)

    # Sync local pair
    tx_hash = router.functions.syncLocalPair(weth_address, dai_address).transact(
        {
            "from": dev_account_address,
            "gas": 3000000,
            "gasPrice": Web3.to_wei("20", "gwei"),
        }
    )
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Synced WETH-DAI pair: ", tx_receipt["status"] == 1 and "Success" or "Failed")
    if RECEIPTS:
        print(tx_receipt)
        
    # Swap WETH to DAI
    daiAmountOut = swap.functions.swapSingleHopExactAmountIn(weth_amount,dai_amount_min).call()
    print(f'Sucessfully swapped {weth_amount} WETH to DAI: {daiAmountOut}')


    # Here is the transaction of swap WETH to DAI just for reference
    tx_hash = swap.functions.swapSingleHopExactAmountIn(weth_amount,dai_amount_min).transact(
        {
            "from": dev_account_address,
            "gas": 3000000,
            "gasPrice": Web3.to_wei("20", "gwei"),
        }
    )
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Swapped WETH to DAI: ", tx_receipt["status"] == 1 and "Success" or "Failed")
    if RECEIPTS:
        print(tx_receipt)

if __name__ == "__main__":
    main()
