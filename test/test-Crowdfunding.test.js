const CrowdFunding = artifacts.require("CrowdFunding");

contract("CrowdFunding", (accounts) => {
  let instance;

  before(async () => {
    instance = await CrowdFunding.deployed();
  });

  it("should add a new campaign", async () => {
    const title = "Test Campaign";
    const description = "This is a test campaign";
    const imageUrl = "https://example.com/image.png";
    const target = 1000;
    const deadline = "2023-04-30";
    await instance.addCampaigns(
      title,
      description,
      imageUrl,
      target,
      deadline,
      { from: accounts[0] }
    );
    const campaigns = await instance.getCampaigns();
    assert.equal(campaigns.length, 1, "Number of campaigns should be 1");
    assert.equal(campaigns[0].title, title, "Campaign title should match");
    assert.equal(
      campaigns[0].description,
      description,
      "Campaign description should match"
    );
    assert.equal(
      campaigns[0].imageUrl,
      imageUrl,
      "Campaign image URL should match"
    );
    assert.equal(campaigns[0].target, target, "Campaign target should match");
    assert.equal(
      campaigns[0].deadline,
      deadline,
      "Campaign deadline should match"
    );
    assert.equal(
      campaigns[0].received,
      0,
      "Campaign received amount should be 0"
    );
    assert.equal(
      campaigns[0].completed,
      false,
      "Campaign should not be completed"
    );
  });

  it("should donate to a campaign", async () => {
    const index = 0;
    const amount = 500;
    const initialBalance = web3.utils.toBN(
      await web3.eth.getBalance(accounts[0])
    );
    await instance.donateToCampaign(index, {
      from: accounts[1],
      value: amount,
    });
    const campaign = await instance.getCampaignDetails(index);
    assert.equal(
      campaign.received,
      amount,
      "Campaign received amount should match"
    );
    assert.equal(campaign.completed, false, "Campaign should not be completed");
    const finalBalance = web3.utils.toBN(
      await web3.eth.getBalance(accounts[0])
    );
    const expectedBalance = initialBalance.add(web3.utils.toBN(amount));
    assert.equal(
      finalBalance.toString(),
      expectedBalance.toString(),
      "Recipient balance should increase by the donated amount"
    );
  });
});
