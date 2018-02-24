pragma solidity ^0.4.16;

contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        gamblerA = 0;
        gamblerB = 0;
        oracle = msg.sender;
        owner = msg.sender;

        for (uint i = 0; i < _outcomes.length; i++) {
            outcomes[i] = _outcomes[i];
        }
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

    modifier outcomeExists(uint outcome) {
        require(outcomes[outcome] >= 0);
        _;
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
        return oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
      assert(msg.value > 0);

      bets[msg.sender] = Bet(_outcome, msg.value, true);

      if (gamblerA == 0) {
        gamblerA = msg.sender;
      } else if (gamblerB == 0 && msg.sender != gamblerA) {
        gamblerB = msg.sender;
      }

      BetMade(msg.sender);
      return true;
    }

      /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        Bet storage betA = bets[gamblerA];
        Bet storage betB = bets[gamblerB];
        uint pot = betA.amount + betB.amount;
        if (betA.outcome == _outcome) {
            winnings[gamblerA] += pot;
        } else if (betB.outcome == _outcome) {
            winnings[gamblerB] += pot;
        }

        contractReset();
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        if (this.balance > withdrawAmount) {
            msg.sender.transfer(withdrawAmount);
        }
        return this.balance;
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
        delete(gamblerA);
        delete(gamblerB);
    }
}
