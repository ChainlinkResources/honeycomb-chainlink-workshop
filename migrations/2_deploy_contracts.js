const WeatherBettingPool = artifacts.require("WeatherBettingPool");

const linkTokenAddress = "0x20fE562d797A42Dcb3399062AE9546cd06f63280";
const oracle = "0x4a3fbbb385b5efeb4bc84a25aaadcd644bd09721";
const jobId = web3.utils.toHex("67c9353f7cc94102b750f84f32027217");
const paymentAmount = web3.utils.toWei("0.1");
const city = "San Francisco"
const date = "2019-10-26";
const minTempF = 72;
const maxTempF = 78;

module.exports = async function (deployer) {
    await deployer.deploy(WeatherBettingPool, linkTokenAddress, oracle, jobId, paymentAmount, city, date, minTempF, maxTempF);
    const weatherBettingPool = await WeatherBettingPool.deployed();
    console.log("Weather Betting Pool contract address: " + weatherBettingPool.address);
};
