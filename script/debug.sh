#/bin/bash

cast call --rpc-url http://127.0.0.1:8545 \
  --from 0x70997970C51812dc3A010C7d01b50e0d17dc79C8  \
  0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 \
  "buyNftBySig(uint256,uint256,uint8,bytes32,bytes32)" \
  0 10000 27 0x0b3e372247d04556f5bb5226607aaf0a822c3ba0961a677727a91df2ef6a54b9 0x156b4d25ee22c2ddb1bc77e1fac29c4588c3d67ee373ad8b69c67b528cf2a64d

 Available Accounts
==================

(0) 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000.000000000000000000 ETH)
(1) 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (10000.000000000000000000 ETH)
(2) 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC (10000.000000000000000000 ETH)
(3) 0x90F79bf6EB2c4f870365E785982E1f101E93b906 (10000.000000000000000000 ETH)
(4) 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65 (10000.000000000000000000 ETH)
(5) 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc (10000.000000000000000000 ETH)
(6) 0x976EA74026E726554dB657fA54763abd0C3a0aa9 (10000.000000000000000000 ETH)
(7) 0x14dC79964da2C08b23698B3D3cc7Ca32193d9955 (10000.000000000000000000 ETH)
(8) 0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f (10000.000000000000000000 ETH)
(9) 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720 (10000.000000000000000000 ETH)

Private Keys
==================

(0) 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
(1) 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
(2) 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
(3) 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
(4) 0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a
(5) 0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba
(6) 0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e
(7) 0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf4356
(8) 0xdbda1821b80551c9d65939329250298aa3472ba22feea921c0cf5d620ea67b97
(9) 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6





 forge create --rpc-url http://127.0.0.1:8545 src/MyTokenCallBack.sol:MyTokenCallBack --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


 forge create --rpc-url http://127.0.0.1:8545 src/MyERC721.sol:MyERC721 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


 forge create --rpc-url http://127.0.0.1:8545 src/NFTMarket.sol:NFTMarket --constructor-args 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 0x5FbDB2315678afecb367f032d93F642f64180aa3 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80





 cast send --rpc-url http://127.0.0.1:8545 0x5FbDB2315678afecb367f032d93F642f64180aa3 "transfer(address, uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 100000000000000  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


cast call --rpc-url http://127.0.0.1:8545 0x0B306BF915C4d645ff596e518fAf3F9669b97016 "getApproved(uint256)" 0

 cast receipt --rpc-url http://127.0.0.1:8545 0x4d83526c6d688f0bd764a8207a7d00b641e628fcbaf12af417ad3f8935238da4


  


  cast send --rpc-url http://127.0.0.1:8545 0x0B306BF915C4d645ff596e518fAf3F9669b97016 "function approve(address, uint256)" 0xa85233C63b9Ee964Add6F2cffe00Fd84eb32338f 0   --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80




  cast call --rpc-url http://127.0.0.1:8545 0x0B306BF915C4d645ff596e518fAf3F9669b97016 "getApproved(uint256)" 0




  cast send --rpc-url http://127.0.0.1:8545 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "mint(address)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266   --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

  cast call --rpc-url http://127.0.0.1:8545 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getNftBalance(address)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

 

  cast send --rpc-url http://127.0.0.1:8545 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "approve(address , uint256 )" 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 0    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

   cast send --rpc-url http://127.0.0.1:8545 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 "list(uint, uint )" 0 10000 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266   --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

  cast call --rpc-url http://127.0.0.1:8545 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "ownerOf(uint256)" 0


   cast send --rpc-url http://127.0.0.1:8545 0x5FbDB2315678afecb367f032d93F642f64180aa3 "transfer(address, uint256)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 10000000000  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


   cast call --rpc-url http://127.0.0.1:8545 0x5FbDB2315678afecb367f032d93F642f64180aa3 "getBalance(address)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8



cast call --rpc-url http://127.0.0.1:8545 0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6 "onSale(uint256)" 0


 forge create --rpc-url https://ethereum-sepolia.blockpi.network/v1/rpc/public src/NFTMarket.sol:NFTMarket --constructor-args 0xfdA4820483E8a58c585C040979914dA24fa0EaaB 0xd3941DB40c5B652EaB37F89F3EDB671Fe69e2200 --private-key 0x38be9db8a3baa30b51f7e3b56958850d6d69559d81f76ab5344d527c40148150


graph init --product subgraph-studio --from-contract 0xf827eecF484997CCd6dB393bf2691557dCACD91c --network sepolia --abi market.abi mynftmarket

forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/MyERC721.s.sol -s "deployNft()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/MyToken.s.sol -s "deployToken()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/NftMarketProxy.s.sol -s "deployProxy()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --ffi



 forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/NftMarketV3.s.sol -s "deployV3Proxy()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --ffi


 forge clean && forge build && npx @openzeppelin/upgrades-core@^1.32.3 validate out/build-info --contract src/NFTMarketV2.sol:NFTMarketV2

forge clean && forge build && npx @openzeppelin/upgrades-core@^1.32.3 validate out/build-info --contract src/NFTMarketV3.sol:NFTMarketV3 



sign:  0x0b3e372247d04556f5bb5226607aaf0a822c3ba0961a677727a91df2ef6a54b9156b4d25ee22c2ddb1bc77e1fac29c4588c3d67ee373ad8b69c67b528cf2a64d1b

0xdd40020a76c4c979e4dabdc767e179b191126be395dfdfd4c93ef99d7fe5d226746b93d0913fa13f9be9aa26503fbdf40213f5fd3f53d4de7bba7b34cba567811c




forge test --match-contract NFTMarketProxyTest --match-test test_proxy -vvv


cast call --rpc-url http://127.0.0.1:8545 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "buyNftBySig(uint256 ,uint256 , uint8 , bytes32 , bytes32 )" 0 10000 27 0x0b3e372247d04556f5bb5226607aaf0a822c3ba0961a677727a91df2ef6a54b9 0x156b4d25ee22c2ddb1bc77e1fac29c4588c3d67ee373ad8b69c67b528cf2a64d --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

forge test --match-contract NFTMarketProxyTest --match-test test_sign


cast call --rpc-url http://127.0.0.1:8545 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "list(uint,uint)" 0 10000  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80



cast send --rpc-url http://127.0.0.1:8545 0x5FbDB2315678afecb367f032d93F642f64180aa3 "function approve(address, uint256)" 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 10000000  --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/MyERC721.s.sol -s "deployNft()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/MyToken.s.sol -s "deployToken()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80



forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/NftMarket.s.sol -s "deployMarket()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/NftMarketProxy.s.sol -s "deployProxy()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --ffi



 forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/NftMarketV3.s.sol -s "deployV3Proxy()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --ffi


forge script --rpc-url http://127.0.0.1:8545 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ./script/NftMarketV3.s.sol -s "getAddr()" --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --ffi

forge clean && forge build && npx @openzeppelin/upgrades-core@^1.32.3 validate out/build-info --contract src/NFTMarketV2.sol:NFTMarketV2

forge clean && forge build && npx @openzeppelin/upgrades-core@^1.32.3 validate out/build-info --contract src/NFTMarketV3.sol:NFTMarketV3 


cast call --rpc-url http://127.0.0.1:8545 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "owner()" 


cast call --rpc-url http://127.0.0.1:8545 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "nonces(address)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8


cast call --rpc-url http://127.0.0.1:8545 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "buyNftBySig(uint256 ,uint256 , uint8 , bytes32 , bytes32 )" 0 10000 

cast call --rpc-url http://127.0.0.1:8545 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "offlineApprove(address to,uint256 tokenId, uint256 price, uint8 v, bytes32 r, bytes32 s )" 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 0 10000 27 0x0b3e372247d04556f5bb5226607aaf0a822c3ba0961a677727a91df2ef6a54b9 0x156b4d25ee22c2ddb1bc77e1fac29c4588c3d67ee373ad8b69c67b528cf2a64d 


cast call --rpc-url http://127.0.0.1:8545 0x5FbDB2315678afecb367f032d93F642f64180aa3 "allowance(address, address)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9

isApprovedForAll(address owner, address operator)

cast call --rpc-url http://127.0.0.1:8545 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "isApprovedForAll(address owner, address operator)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9

cast call --rpc-url http://127.0.0.1:8545 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "buyNftBySig(uint256,uint256,uint8,bytes32,bytes32)" 0 10000 27 0x0b3e372247d04556f5bb5226607aaf0a822c3ba0961a677727a91df2ef6a54b9 0x156b4d25ee22c2ddb1bc77e1fac29c4588c3d67ee373ad8b69c67b528cf2a64d --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

