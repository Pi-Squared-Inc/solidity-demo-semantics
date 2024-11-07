#!/usr/bin/python3
from web3 import Web3
from web3.middleware import SignAndSendRawMiddlewareBuilder
import time

simple_usdc_hex = open('test/demo-contracts/USDCMock.kore.bin').read().rstrip()

w3 = Web3(Web3.HTTPProvider('http://localhost:8545'))
sender = w3.eth.account.create()
pk = w3.to_hex(sender.key)
print(sender.address)

tx_hash = w3.eth.send_transaction({'from': w3.eth.accounts[0],'to':sender.address,'value':1000000000000000000})
print(tx_hash)
w3.eth.wait_for_transaction_receipt(tx_hash)

w3.middleware_onion.inject(SignAndSendRawMiddlewareBuilder.build(sender), layer=0)

deploy_usdc_tx = {
  'from': sender.address,
  'data': simple_usdc_hex,
  'to': '',
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

# deploy USDC
print("Deploying USDC...")

tx_hash = w3.eth.send_transaction(deploy_usdc_tx)
print(tx_hash)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print(receipt)
usdc_address = receipt['contractAddress']

mint_usdc_data = '40c10f19000000000000000000000000' + sender.address[2:] + '00000000000000000000000000000000000000000000000000000000000003e8'

mint_usdc_tx = {
  'from': sender.address,
  'data': mint_usdc_data,
  'to': usdc_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

# mint USDC
print("Minting USDC...")

tx_hash = w3.eth.send_transaction(mint_usdc_tx)
print(tx_hash)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print(receipt)
print("USDC Address:", usdc_address)

balanceOf_usdc_data = '70a08231000000000000000000000000' + sender.address[2:]

balanceOf_usdc_tx = {
  'from': sender.address,
  'data': balanceOf_usdc_data,
  'to': usdc_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

# balanceOf USDC
print("balanceOf USDC...")

balance = w3.eth.call(balanceOf_usdc_tx)
print(balance)

transfer_usdc_data = 'a9059cbb000000000000000000000000111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000003e8'

transfer_usdc_tx = {
  'from': sender.address,
  'data': transfer_usdc_data,
  'to': usdc_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

# transfer USDC
print("transfer USDC...")

tx_hash = w3.eth.send_transaction(transfer_usdc_tx)
print(tx_hash)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print(receipt)

# balanceOf USDC
print("balanceOf USDC...")

balance = w3.eth.call(balanceOf_usdc_tx)
print(balance)

balanceOf_usdc_data2 = '70a082310000000000000000000000001111111111111111111111111111111111111111'
balanceOf_usdc_tx['data'] = balanceOf_usdc_data2

balance = w3.eth.call(balanceOf_usdc_tx)
print(balance)

# decimals USDC
decimals_usdc_data = '313ce567'
decimals_usdc_tx = {
  'from': sender.address,
  'data': decimals_usdc_data,
  'to': usdc_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

decimals = w3.eth.call(decimals_usdc_tx)
print("Decimals:", int(decimals.hex(), 16))

# name
name_usdc_data = '06fdde03'
name_usdc_tx = {
  'from': sender.address,
  'data': name_usdc_data,
  'to': usdc_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

name = w3.eth.call(name_usdc_tx)
name = w3.to_text(name)
print("Name:", name)

# symbol
symbol_usdc_data = '95d89b41'
symbol_usdc_tx = {
  'from': sender.address,
  'data': symbol_usdc_data,
  'to': usdc_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

symbol = w3.eth.call(symbol_usdc_tx)
symbol = w3.to_text(symbol)
print("Symbol:", symbol)
