pragma solidity 0.4.19;


contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        owner = msg.sender;
        /* assuming an outcome cannot be zero */
        outcomeLength = _outcomes.length;
        for (uint i = 0; i < _outcomes.length; i++) {
            require(_outcomes[i] > 0);
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
    uint outcomeLength;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() { if (msg.sender == owner) _;}
    modifier oracleOnly() { if (msg.sender == oracle) _;}
    modifier outcomeExists(uint outcome) {
        for (uint i = 0; i < outcomeLength; i++) {
          if (outcomes[i] == outcome)
            _;
        }
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        require(_oracle != gamblerA && _oracle != gamblerB);

        oracle = _oracle; /* Vulnerability in human trust */
        return oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public outcomeExists(_outcome) payable returns (bool) {
        require(msg.sender != oracle);
        require(!bets[msg.sender].initialized); // user cannot double bet

        if (!bets[gamblerA].initialized) {
            bets[msg.sender] = Bet(_outcome, msg.value, true);
            gamblerA = msg.sender;
            BetMade(gamblerA);
            return true;
        } else if (!bets[gamblerB].initialized) {
            bets[msg.sender] = Bet(_outcome, msg.value, true);
            gamblerB = msg.sender;
            BetMade(gamblerB);
            return true;
        }

        return false; // Two bets already exist
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        require(bets[gamblerA].initialized && bets[gamblerB].initialized); // Two bets must be placed

        uint totalAmt = bets[gamblerA].amount + bets[gamblerB].amount;
        if(bets[gamblerA].outcome == _outcome) { /* Gambler A won this round */
            winnings[gamblerA] += totalAmt;
        }
        else if(bets[gamblerB].outcome == _outcome) { /* Gambler B won this round */
            winnings[gamblerB] += totalAmt;
        }
        else { /* Oracle wins */
            winnings[oracle] += totalAmt;
        }

        /* Reset the Game */
        BetClosed();
        delete bets[gamblerA];
        delete bets[gamblerB];
        delete gamblerA;
        delete gamblerB;
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(winnings[msg.sender] >= withdrawAmount);

        winnings[msg.sender] -= withdrawAmount;
        if(!msg.sender.send(withdrawAmount))
            winnings[msg.sender] += withdrawAmount;

        return winnings[msg.sender]; // return the remaining winnings
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
        BetClosed();
        delete oracle; // owner must pick an oracle again
        delete bets[gamblerA];
        delete bets[gamblerB];
        delete gamblerA;
        delete gamblerB;
    }
}
