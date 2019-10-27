pragma solidity 0.4.24;

import "./BettingPool.sol";

contract WeatherBettingPool is BettingPool
{
    string public city;
    string public date;
    int256 public minTempF;
    int256 public maxTempF;
    
    constructor(
        address _link,
        address _oracle,
        bytes32 _jobId,
        uint256 _oraclePaymentAmount,
        string _city,
        string _date,
        int256 _minTempF,
        int256 _maxTempF
        )
    BettingPool(
        _link,
        _oracle,
        _jobId,
        _oraclePaymentAmount
        )
    public
    {
        city = _city;
        date = _date;
        minTempF = _minTempF;
        maxTempF = _maxTempF;
    }

    function checkResult() external onlyOwner returns (bytes32 requestId)
    {
        require(!fulfilled, "The result has already been delivered.");
        Chainlink.Request memory req = buildChainlinkRequest(jobId, this, this.fulfill.selector);
        req.add("q", city);
        req.add("date", date);
        req.add("copyPath", "data.weather.0.avgtempF");
        requestId = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePaymentAmount);
    }

    function fulfill(bytes32 _requestId, int256 _data)
    public
    recordChainlinkFulfillment(_requestId)
    {
        if (_data >= minTempF && _data <= maxTempF)
        {
            fulfilled = true;
            teamADidWin = true;
        }
        else if (_data < minTempF || _data > maxTempF)
        {
            fulfilled = true;
            teamADidWin = false;
        }
    }
}
