pragma solidity ^0.8.6;

contract StoreCertificate {
    uint256 public cert_id = 0;
    uint256 numberOfVotesRequired = 1;
    address _owner;

    constructor() {
        // assign the owener and let them be the first issuer
        _owner = msg.sender;
        isIssueer[msg.sender] = true;
    }

    struct Certificate {
        string name;
        uint256 timeOfIssue;
        string hashOfCertificate;
        string major;
        uint256 GPA;
    }
    // universities
    mapping(address => bool) public isIssueer;
    // given a hash of a certificate returns the name of the issuer
    mapping(string => address) public issuerOfCertificate;
    //given an id returns a certificate
    mapping(uint256 => Certificate) public certificates;
    // keep track of the votes for the new issuers
    mapping(address => uint256) public votesToRegister;

    // events
    event RegisteredIssuer(address _issuer);
    event VotedForIssuer(address votedFor, address votedTo);
    event CreatedCertificate(
        uint256 cert_id,
        Certificate certificate,
        address issuer
    );

    function voteForIssuer(address _issuer) public {
        // check if the sender is an issuer
        require(isIssueer[msg.sender] == true);
        // check if the address voted for isn't an issuer
        require(isIssueer[_issuer] == false);
        // add a vote
        votesToRegister[_issuer] += 1;
        emit VotedForIssuer(msg.sender, _issuer);
        // check if the numbers or votes required are met
        if (votesToRegister[_issuer] >= numberOfVotesRequired) {
            isIssueer[_issuer] = true;
            delete votesToRegister[_issuer];
            emit RegisteredIssuer(_issuer);
        }
    }

    function registerIssuer() public {
        // check if already there
        // require(isIssueer[msg.sender] = false);
        // start the voting
        votesToRegister[msg.sender] = 0;
    }

    function issueCertificates(
        string memory name,
        string memory major,
        string memory hashOfCertificate,
        uint256 gpa
    ) public {
        // check if they're an issuer
        require(isIssueer[msg.sender] == true);
        // create the certificate
        Certificate memory certificate;
        // fill the certrificate with the provided info
        certificate.name = name;
        certificate.timeOfIssue = block.timestamp;
        certificate.major = major;
        certificate.hashOfCertificate = hashOfCertificate;
        certificate.GPA = gpa;
        certificates[cert_id] = certificate;
        issuerOfCertificate[hashOfCertificate] = msg.sender;
        emit CreatedCertificate(cert_id, certificate, msg.sender);
        cert_id++;
    }
}
