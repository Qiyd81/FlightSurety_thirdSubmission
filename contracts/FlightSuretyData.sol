pragma solidity ^0.5.16;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false
    address private appContractOwner;
    mapping(address => bool) public authorizedAppContracts;

    // Airlines
    struct Airline {
        address airlineAddress;
        string airlineID;
        bool isNewAdded;
        bool isRegistered;
        uint256 hasFund;
        uint256 voteCount;
    }
    mapping(address => Airline) private airlines;
    mapping(address => Airline) private newAddedAirlines;
    mapping(address => Airline) private registeredAirlines;
    mapping(address => Airline) private hasFundAirlines; 
    uint256 private airlineCount = 0;
    uint256 private newAddedAirlineCount = 0;
    uint256 private registeredAirlineCount = 0;
    uint256 private hasFundAirlineCount = 0;

    mapping(bytes32 => address[]) private flights;    
    mapping(address => uint256) private insureesBalance;

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                address firstAirline, string memory firstAirlineID
                                ) 
                                public 
    {
        contractOwner = msg.sender;
        airlines[firstAirline] = Airline({
                                    airlineAddress: firstAirline,
                                    airlineID: firstAirlineID,
                                    isNewAdded: true,
                                    isRegistered: true,
                                    hasFund: 0,
                                    voteCount: 10000
                            });
        airlineCount++;
        registeredAirlineCount++;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational() 
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireAppContractAuthorized()
    {
        require(authorizedAppContracts[msg.sender] == true, "AppContract is not authorized");
        _;
    }

    // modifier requireAppContractOwner()
    // {
    //     require(msg.sender == appContractOwner, "Caller need to be App contract owenr");
    //     _;
    // }

    modifier requireisRegisteredAirline(address _airline)
    {
        require(airlines[_airline].isRegistered == true, "Airline need to be isRegistered");
        _;
    }

    modifier requirehasFundAirline()
    {
        require(airlines[msg.sender].hasFund >= (10 ether), "Airline need to have more than 10 ether");
        _;
    }
    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
        return operational;
    }


    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus
                            (
                                bool mode
                            ) 
                            external
                            requireContractOwner 
    {
        operational = mode;
    }

    function authorizeAppContract(address _appContract) external requireIsOperational requireContractOwner 
    {
        authorizedAppContracts[_appContract] = true;
    }
    function deauthorizeAppContract(address _appContract) external requireContractOwner 
    {
        delete authorizedAppContracts[_appContract];
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/
    function addAirline (address newAirline, string calldata newAirlineID)
            external payable requireIsOperational requireAppContractAuthorized 
            requirehasFundAirline() {
        _addAirline(newAirline, newAirlineID);
    }

    /**
     * @dev Add an airline to the registration queue
     *
     */
    function _addAirline (address newLine, string memory newLineID) private {
        Airline memory airline = Airline(newLine, newLineID, true, false, 0, 0);
        airlines[newLine] = airline;
        newAddedAirlines[newLine] = airline;
    }

    function isAppContractAuthorized 
                            (
                                address _appContract 
                            ) 
                            external 
                            view 
                            returns(bool) 
    {
        return authorizedAppContracts[_appContract];
    }

    function isAirlineRegistered
                            (
                                address _airline
                            )
                            external
                            view
                            returns(bool)
    {
        return airlines[_airline].isRegistered;
    }

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   

    function registerAirline
                                (
                                    address newLine,
                                    string calldata newLineID
                                )
                                external
                                requireIsOperational requireAppContractAuthorized 
                                requirehasFundAirline()
    {
        require(!registeredAirlines[newLine].isRegistered, "Airline is already registered.");
        Airline memory airline = Airline(newLine, newLineID, true, true, 0, 9000);
        airlines[newLine] = airline;
        registeredAirlines[newLine] = airline;
        registeredAirlineCount++;
        
    }
    // function registerAirline
    //                         ( 
    //                             address airline, address applyAirline  
    //                         )
    //                         external requireIsOperational requireAppContractOwner requireisRegisteredAirline(airline)
    //                         requireFundedAirline(airline)
    // {
    //     _registerAirline(applyAirline);
    // }

    // function _registerAirline(address applyAirline) 
    //         private
    // {
    //     airlines[applyAirline].isRegistered = true;
    // }

    function vote(address newAirline)
            external requireIsOperational requireAppContractAuthorized
            requirehasFundAirline()
    {
        require(airlines[newAirline].isNewAdded, "Airline is not in the newAddedAirlines to be voted");
        require(!airlines[newAirline].isRegistered, "Airline is already registered");
        // require(!(airlines[newAirline].hasFund > 0),"Airline is already has funded");
        airlines[newAirline].voteCount++;
    }


    // requireisRegisteredAirline
    function fundAirline(address airline, uint256 value) 
            external requireIsOperational requireAppContractAuthorized requireisRegisteredAirline(airline)
    {
        // require(airlines[airline].isRegistered == true, "airline not registered yet");
        airlines[airline].hasFund += value;
        hasFundAirlines[airline] = airlines[airline];
        hasFundAirlineCount++;
    }

   /**
    * @dev Buy insurance for a flight
    *
    */   
    function buy
                            (  
                                address airline, string calldata flight, uint256 timestamp, address insuree                           
                            )
                            external
                            payable requireIsOperational requireAppContractAuthorized
    {
        require((insureesBalance[insuree] += msg.value) <= (1 ether), "Passengers can buy maximum 1 ether insurance");
        address(this).transfer(msg.value);
        bytes32 flightkey = getFlightKey(airline, flight, timestamp);
        flights[flightkey].push(insuree);
        insureesBalance[insuree] += (msg.value);
    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
                                    address airline, string calldata flight, uint256 timestamp
                                )
                                external requireIsOperational requireAppContractAuthorized
    {
        bytes32 flightkey = getFlightKey(airline, flight, timestamp);
        for (uint256 i = 0; i < flights[flightkey].length; i++) 
        {
            uint256 currentBalance = insureesBalance[flights[flightkey][i]];

            uint256 newBalance = currentBalance * 2;
            insureesBalance[flights[flightkey][i]] = newBalance;
        }
        delete flights[flightkey];
    }
    

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
                                address payable insuree
                            )
                            external payable requireIsOperational requireAppContractAuthorized
    {
        require(insureesBalance[insuree] > 0, "Insuree need to be greater than 0");
        uint256 value = insureesBalance[insuree];
        insureesBalance[insuree] = 0;
        insuree.transfer(value);
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function dataFund
                            (   
                            )
                            public
                            payable
    {
        address(this).transfer(msg.value);
    }

    function getFlightKey
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        )
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }


    /**
     * @dev Returns information about Airline.
     */
    function getAirline(address airlineAddress) external view requireIsOperational requireAppContractAuthorized
                                                returns(string memory id, bool isRegistered, uint hasFund, uint voteCount) {
        Airline memory airline = airlines[airlineAddress];
        return(airline.airlineID, airline.isRegistered, airline.hasFund, airline.voteCount);
    }

    function isAirlineNewAdded(address airline) external view requireIsOperational requireAppContractAuthorized returns (bool) {
        return airlines[airline].isNewAdded;
    }

    /**
     * @dev Returns the number of Airline votes.
     */
    function getAirlineVoteCount(address airlineAddress) external view requireIsOperational requireAppContractAuthorized returns(uint256) {
        Airline memory airline = airlines[airlineAddress];
        return(airline.voteCount);
    }

    /**
     * @dev Returns the number of Airlines.
     */
    function getAirlineCount() external view requireIsOperational requireAppContractAuthorized returns(uint256) {
        return airlineCount;
    }

    function gethasFundAirlineCount() external view requireIsOperational requireAppContractAuthorized returns(uint256) {
        return hasFundAirlineCount;
    }
    /**
     * @dev Get insurees credit balance.
     */
    function getInsureesBalance(address insuree) external view requireIsOperational returns(uint256) {
        return insureesBalance[insuree];
    }
    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    function() 
                            external 
                            payable 
    {
        dataFund();
    }


}



