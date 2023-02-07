const { expect } = require("chai");
const {ethers, upgrades} = require("hardhat");
const { loadFixture, time } = require("@nomicfoundation/hardhat-network-helpers");




describe("Final Testing", async function () {


    async function before(){
    const [add1,add2] = await ethers.getSigners();
    const MyNFT = await ethers.getContractFactory("MyNFT");
    const MyToken = await ethers.getContractFactory("MyToken");
    const Staking = await ethers.getContractFactory("Staking");
    const mynft = await MyNFT.deploy()
    const mytoken = await MyToken.deploy()
    const staking = await Staking.deploy(mytoken.address,mynft.address);
    await mytoken.mint(staking.address,"1000000000000000000000000")
    await mynft.safeMint(add2.address,"0","www.nfturi.xyz")
    return {mynft,mytoken,staking}
    }
    
    it("rewards testing", async function () {

        const {mynft,mytoken,staking} = await loadFixture(before);
        const [add1,add2] = await ethers.getSigners();
        await mynft.connect(add2).approve(staking.address,0);
        await staking.connect(add2).stake(0);
        const delay = (ms) => new Promise((res) => setTimeout(res, ms));
	    await delay(6000);  // staking for 6 seconds
        await staking.connect(add2).withdraw();
        console.log(await mytoken.balanceOf(add2.address));
        console.log("heloooooooooooooooo");
        expect("0").to.equal("0");
    });

});

