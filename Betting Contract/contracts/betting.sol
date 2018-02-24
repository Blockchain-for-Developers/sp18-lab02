/*
 * @title Betting contract
 * @authors: Sangbin Cho, Sanjay Goel and Jai Kumar
 *
 * @supports multiple gamblers
 */

pragma solidity 0.4.20;

contract Betting {

    // Representing a single gambler.
    struct Gambler {
        bool hasBetted;  // if true, that gambler already betted to prevent multiple betting
        uint expectedOutcome;   // index of the selected outcome
        uint bettingWei;   // wei amount putting for this bet
    }

    // Representing an outcome
    uint[] public outcomes;

    // Keeping balances information
    mapping (address => uint256) public balances;

    //Events
    event oracleSelected();
    event bettingStarted();
    event invalidBettingOutcomeEntered(address gAddr);
    event bettingEnded();
    event winnerAnnounced(uint winningOutcomeNumber);
    event gamblerBetted(address gambler);
    event rewardDispered();
    event LogTransfer(address sender, address to, uint amount);

    // Flag to know if betting is open yet
    bool public bettingIsOpen = false;

    // Winning outcome
    uint winningOutcome;

    // Oracle
    address public oracle;

    // Owner
    address public contractOwner;

    // This declares a state variable that
    // stores a `Gambler` struct for each possible address.
    mapping(address => Gambler) public gamblers;
    
    //Bet counter for gamblers
    mapping (address => uint) public betCounter;
    
    //Number of total bets
    uint public numberOfBets;
    
    //Total money poured in
    uint totalBetAmount;

    // Mapping for (bets outcome => gambler address)
    mapping (uint => address[]) public bets;

    // Mapping for (bets outcome => total amount poured in for particular outcomes)
    mapping (uint => uint) public outcomesAmount;
    
    modifier onlyOwner {
      require(msg.sender == contractOwner);
      _;
    }
    
    modifier onlyOracle {
      require(msg.sender == oracle);
      _;
    }
    
    modifier gamblerOnly() {
      require(msg.sender != oracle);
      require(msg.sender != contractOwner);
      _;
    }
    
    modifier canBetOnlyOnce() {
      require(betCounter[msg.sender] == 0);
      _;
    }

    // Create a new betting to choose one of `outcomeNumbers`.
    function Betting(uint[] outcomeNumbers) public {
      contractOwner = msg.sender;
      
      //Make sure there is at least two outcomes, else betting has no point
      require(outcomeNumbers.length > 1);

      for(uint i = 0; i < outcomeNumbers.length; i++) {
        // Make sure these outcome numbers are unique - no duplicates
        if (!_check_uint_item_exists_in_array(outcomeNumbers[i], outcomes)) {
          outcomes.push(outcomeNumbers[i]);
        }
      }
    }

    // Choose oracle
    function chooseOracle(address oracleAddress) public onlyOwner {
      //Make sure bet has not started yet
      require(!bettingIsOpen && winningOutcome == 0 && oracle == 0X0);

      // Make sure owner cannot select himself/herself as the oracle
      require(oracleAddress != contractOwner);

      oracle = oracleAddress;
      oracleSelected();
      bettingIsOpen = true; // Open betting for gambler
      bettingStarted();
    }

    // End betting
    function endBetting() public onlyOwner {
      bettingIsOpen = false;
      bettingEnded();
    }

    // Make a bet
    function makeABet(uint bettedOutcome) public payable gamblerOnly canBetOnlyOnce {
      address gamblerAddress = msg.sender;
      
      // Make sure gambling is open first
      require(bettingIsOpen);

      // weiAmount must be greater than 0
      require(msg.value > 0);
      
      // Make sure betted Outcome is among the defined outcomes
      if(!_check_uint_item_exists_in_array(bettedOutcome, outcomes)){
        invalidBettingOutcomeEntered(gamblerAddress);
        revert();
      }
    
      //Finally record the betting
      gamblers[gamblerAddress] = Gambler({
        hasBetted: true,
        expectedOutcome: bettedOutcome,
        bettingWei: msg.value
      });

      //Increment bet amount
      totalBetAmount += msg.value;

      // Save it for iterating at money dispering time
      bets[bettedOutcome].push(gamblerAddress);
      outcomesAmount[bettedOutcome] += msg.value;
      
      numberOfBets += 1;
      gamblerBetted(gamblerAddress);
    }

    // A utility function to find if an uint element exists in an array
    function _check_uint_item_exists_in_array(uint needle, uint[] haystack) public pure returns(bool decision) {
      for (uint i = 0; i < haystack.length; i++) {
        if (needle == haystack[i]) {
          return true;
        }
      }

      return false;
    }

    // Select winnining outcome
    function selectWinningOutcome(uint selectedOutcome) public onlyOracle {
      require(bettingIsOpen); // Betting is still open
      require(numberOfBets > 1); // Must have more than one gamblers participated till now

      for (uint i =0; i < outcomes.length; i++) {
        if (outcomes[i] == selectedOutcome) {
          winningOutcome = outcomes[i];
          break;
        }
      }
      // Make sure the selectedOutcome is in the list of winningOutcome, else bail out
      require(winningOutcome != 0);
      bettingIsOpen = false;

      bettingEnded();
      winnerAnnounced(winningOutcome);

      // Now disperse the reward
      disperseReward(winningOutcome);
    }

    //Allocate the reward
    function disperseReward(uint selectedOutcome) public onlyOracle payable {
      require(!bettingIsOpen); //Betting must be closed by now
      require(selectedOutcome != 0); // Winning outcome must have bene selected

      // If no gambler betted to the winning outcome, the oracle wins the sum of the funds
      if (bets[selectedOutcome].length == 0) {
        //send money to oracle
        if(!transfer(oracle, totalBetAmount)){
           revert();
        } 
      } else {
        // First find winning gamblers
        address[] storage winning_gamblers = bets[selectedOutcome];
        uint winning_gamblers_total_betted_amount = outcomesAmount[selectedOutcome];

        // The winners receive a propotional share of the total funds at stake if they all bet on the correct outcome
        for (uint i = 0; i < winning_gamblers.length; i++) {
          // TODO - use safemath here for the integer division
          uint amount_to_transfer = ((gamblers[winning_gamblers[i]].bettingWei) / winning_gamblers_total_betted_amount )*totalBetAmount;
          transfer(winning_gamblers[i], amount_to_transfer);
        }
      }

      rewardDispered();
    }

    // Tranfser the reward
    function transfer(address to, uint value) public returns(bool success) {
      if(balances[msg.sender] < value) revert();
      balances[msg.sender] -= value;
      to.transfer(value);
      LogTransfer(msg.sender, to, value);
      return true;
    }

    // Fall back funtion
    function () public payable {}
}