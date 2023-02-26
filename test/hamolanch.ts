import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract, ContractFactory, } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import "@nomiclabs/hardhat-etherscan";


describe("DonationTest", function () {
  let token: Contract;
  let Token: ContractFactory;
  let deployer: SignerWithAddress;
  let Jared: SignerWithAddress;
  let Jack: SignerWithAddress;
  let Gamo: SignerWithAddress;
  const zeroAddress = "0x0000000000000000000000000000000000000000";


  before(async function () {
    [deployer, Jack, Jared , Gamo] = await ethers.getSigners();
  });

  beforeEach(async function () {
    Token = await ethers.getContractFactory("hamolanche");
    token = await Token.deploy();
    await token.deployed();
  });

  it("Should deploy correctly", async function () {
    expect(await token.name()).to.equal("hamolanche");
    expect(await token.symbol()).to.equal("HLA");
    expect(await token.decimals()).to.equal(18);
  });

  describe("Mint", function () {
    it("Should execute mint correctly", async function () {
      await token.mint(deployer.address, ethers.utils.parseEther("150"));
      expect(await token.balanceOf(deployer.address)).to.equal(ethers.utils.parseEther("150"));
      expect(await token.totalSupply()).to.equal(ethers.utils.parseEther("150"));
    });

    it("Should fail to mint(AccessControl)", async function () {
      expect(token.connect(Jared).mint(deployer.address, ethers.utils.parseEther("145"))).to.be.revertedWith('revertMessage');
    })
  });

  describe("Burn", function () {
    it("Should burn correctly", async function () {
      await token.mint(deployer.address, ethers.utils.parseEther("150"));
      await token.burn(deployer.address, ethers.utils.parseEther("120"));
      expect(await token.balanceOf(deployer.address)).to.equal(ethers.utils.parseEther("30"));
      console.log("balance before ", await token.balanceOf(Jared.address))
      await token.mint(Jared.address,100) 
      console.log("balance after ", await token.balanceOf(Jared.address))
    });

    it("Should fail to burn(AccessControl)", async function () {
      expect(token.connect(Jared).burn(deployer.address, ethers.utils.parseEther("5"))).to.be.revertedWith('revertMessage');//ethers.utils.parseEther("5") щоб не писати 5 і 18 нулів
    });
  })

  // Deployer sends costs to Jared
  describe("Transfer", function () {
    it("Should execute transfer correctly", async function () {
      await token.mint(deployer.address, ethers.utils.parseEther("150"));
      await token.transfer(Jared.address, ethers.utils.parseEther("100"));
      expect(await token.balanceOf(Jared.address)).to.equal(ethers.utils.parseEther("100"));
    });

    it("Should execute transfer correctly", async function () {
        await token.mint(Jared.address, ethers.utils.parseEther("100"));
        await token.connect(Jared).transfer(Jack.address,50);
        console.log(await token.balanceOf(Jared.address))
      });

      it("Should execute transfer correctly", async function () {
        await token.mint(Gamo.address, ethers.utils.parseEther("110"));
        await token.connect(Gamo).transfer(Jared.address, 70);
        console.log(await token.balanceOf(Gamo.address))
      });

    it("Should fail to transfer(Insufficient balance!)", async function () {
      await token.mint(deployer.address, ethers.utils.parseEther("150"));
      expect(token.transfer(Jared.address, ethers.utils.parseEther("200"))).to.be.revertedWith("Insufficient balance!");
    });
  });

  // Jack transfers costs from deployers account to Jared
  it("Should execute transferFrom correctly", async function () {
    await token.mint(deployer.address, ethers.utils.parseEther("100"));
    await token.approve(Jack.address, ethers.utils.parseEther("25"));
    expect(await token.allowance(deployer.address, Jack.address)).to.equal(ethers.utils.parseEther("25"));
    expect(token.connect(Jack).transferFrom(deployer.address, Jared.address, ethers.utils.parseEther("30"))).to.be.revertedWith("Allowance declined!");
    expect(token.connect(Jack).transferFrom(deployer.address, Jared.address, ethers.utils.parseEther("300"))).to.be.revertedWith("Insufficient balance!");
    await token.connect(Jack).transferFrom(deployer.address, Jared.address, ethers.utils.parseEther("20"));
    expect(await token.balanceOf(Jared.address)).to.equal(ethers.utils.parseEther("20"));
  })

  it("Should emit events correctly", async function () {
    await expect(token.mint(Jared.address, ethers.utils.parseEther("110"))).to.emit(token, 'Transfer')
      .withArgs(zeroAddress, Jared.address, ethers.utils.parseEther("110"));

    await expect(token.burn(Jared.address, ethers.utils.parseEther("100"))).to.emit(token, 'Transfer')
      .withArgs(Jared.address, zeroAddress, ethers.utils.parseEther("100"));
  });
});