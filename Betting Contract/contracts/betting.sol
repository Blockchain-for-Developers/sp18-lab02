pragma solidity 0.4.19;


contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
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
    uint outLen;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();
    event oracleSet();

    /* Uh Oh, what are these? */
    modifier ownerOnly() { 
        require (msg.sender == owner);
        _;
    }
    
    modifier oracleOnly() { 
        require (msg.sender == oracle);
         _;
     }
    
    modifier outcomeExists(uint outcome) {
        uint outcomeNum = 0;
        while (outcomeNum++ && outcomeNum < outLen) {
        if (outcomes[outcomeNum] == outcome) {
            _;
            }
        }


    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        require (_oracle != gamblerA);
        require (_oracle != gamblerB);
        oracle = _oracle;

        oracleSet();
        return oracle;

    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        require (msg.sender != oracle);
        require (bets[msg.sender] == false);

        if (bets[gamblerA].initialized) {
            bets[msg.sender] = Bet(_outcome,msg.value,true);
            outLen+=1;
            gamblerB = msg.sender;
            BetMade(gamblerB);
            return true;
        }

        else if (bets[gamblerB].initialized) {
            bets[msg.sender] = Bet(_outcome,msg.value,true);
            outLen+=1;
            gamblerA = msg.sender;
            BetMade(gamblerA);
            return true;
        }
        else {
            return false;
        }

    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {

    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        require (winnings[msg.sender] >= withdrawAmount);


        winnings[msg.sender] -= withdrawAmount;
        if (msg.sender.send(withdrawAmount)) {
            return winnings[msg.sender];
        }
        else {
            winnings[msg.sender] += withdrawAmount;
            return winnings[msg.sender]; //cant return -1 bc uint
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
        delete gamblerA;
        delete gamblerB;
        delete oracle;
        delete bets[gamblerA];
        delete bets[gamblerB];

        BetClosed();
    }
}
