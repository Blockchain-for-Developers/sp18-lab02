pragma solidity 0.4.19;


contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        for (uint i = 0; i < _outcomes.length; i ++) {
            outcomes[i] = _outcomes[i];
        }
        owner = msg.sender;
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    modifier oracleOnly() {
        require(msg.sender == oracle);
        _;
    }

    modifier gamblersOnly() {
        require(msg.sender == gamblerA || msg.sender == gamblerB);
        _;
    }

    modifier outcomeExists(uint outcome) {
      require(isIn(outcome, outcomes));
      _;
  }

  function isIn(uint item, uint[] list) public returns (bool) {
      for (uint i = 0; i < list.length; i++) {
          if (list[i]==item) {
              return true;
          }
      return false;
      }
  }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
    }

    /* Gamblers place their bets, preferably after calling tcomes */
    function makeBet(uint _outcome) public payable gamblersOnly() returns (bool) {
        if (checkOutcomes(_outcome) == 0) {
            return false;
        }
        uint amount = msg.value;
        address sender = msg.sender;
        Bet memory bet = Bet(_outcome, amount, true);
        bets[sender] = bet;
        return true;
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        Bet storage betA = bets[gamblerA];
        Bet storage betB = bets[gamblerB];
        if (betA.outcome == betB.outcome) {
            gamblerA.transfer(betA.amount);
            gamblerB.transfer(betB.amount);
        } else if (betA.outcome != _outcome && betB.outcome != _outcome) {
            oracle.transfer(betA.amount + betB.amount);
        } else if (betA.outcome == _outcome) {
            winnings[gamblerA] *= 2;
        } else {
            winnings[gamblerB] *= 2;
        }
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        if (winnings[msg.sender] >= withdrawAmount) {
            msg.sender.transfer(withdrawAmount);
            return withdrawAmount;
        } else {
            return 0;
        }
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
        return outcomes[outcome];
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
        delete(bets[gamblerA]);
        delete(bets[gamblerB]);
    }
}
