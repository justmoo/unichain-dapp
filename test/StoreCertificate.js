const storeCertificates = artifacts.require("StoreCertificate");

let accounts;
contract("StoreCertificate", (accounts) => {

    it("it should register an issuer", async () => {
        let store = await storeCertificates.deployed()
        await store.registerIssuer({ from: accounts[0] });
        assert(await store.votesToRegister(accounts[0]) == 0);
    });

    it("check if the owner is an issuer", async () => {
        let store = await storeCertificates.deployed()
        assert(await store.isIssueer(accounts[0]) == true);
    });

    it("check voting functionality", async () => {
        let store = await storeCertificates.deployed()
        await store.registerIssuer({ from: accounts[1] });
        await store.voteForIssuer(accounts[1]);
        assert(await store.isIssueer(accounts[1]) == true);
    });

    it("issuing certificate", async () => {
        let store = await storeCertificates.deployed()
        await store.issueCertificates("Mohammed aljasser", "software engineer", "smaple hash", "5");
        let certificate = await store.certificates(0)
        assert(certificate.name == "Mohammed aljasser");
        assert(certificate.major == "software engineer");
        assert(certificate.GPA == "5");
    });
})