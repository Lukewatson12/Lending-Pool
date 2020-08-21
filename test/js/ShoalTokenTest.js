const ShoalToken = artifacts.require("ShoalToken");

contract("ShoalToken", accounts => {

    const alice = accounts[0];
    const bob = accounts[1];
    const charlie = accounts[2];

    let shoalInstance;

    beforeEach(async function () {
        return await ShoalToken.new()
            .then(function (instance) {
                shoalInstance = instance;
            });
    });

    it("It should mint an initial supply of 0 tokens", async () => {
        const tokenSupply = await shoalInstance.totalSupply();
        assert.equal(
            0,
            tokenSupply,
            "Total token supply should be null when contract is created"
        );
    });

    it("It should allow minting of more tokens", async () => {
        await shoalInstance.mint(alice, 100);
        const aliceBalance = await shoalInstance.balanceOf(alice);

        const tokenSupply = await shoalInstance.totalSupply();
        assert.equal(
            100,
            tokenSupply,
            "There should be 100 tokens minted"
        );

        assert.equal(
            100,
            aliceBalance,
            "Alice should have 100 minted tokens"
        );
    });

    it("It should permit transferring of tokens between addresses", async () => {
        await shoalInstance.mint(alice, 100);
        await shoalInstance.transfer(bob, 50);

        const aliceBalance = await shoalInstance.balanceOf(alice);
        const bobBalance = await shoalInstance.balanceOf(bob);

        assert.equal(
            50,
            bobBalance,
            "Bob should have received 50 tokens"
        );

        assert.equal(
            50,
            aliceBalance,
            "Alice should have transferred 50 tokens"
        );
    });

    it("It should have a view function with calculates the total share of the pool for each address", async () => {
        await shoalInstance.mint(alice, 100);
        await shoalInstance.mint(bob, 100);
        await shoalInstance.mint(charlie, 100);

        const bobShare = await shoalInstance.calculateShareOfTokens(bob);

        assert.equal(
            333333,
            parseInt(bobShare),
            "Bobs share is not equal to the expected amount"
        )
    });

    it("It can calculate complex percentages", async () => {
        await shoalInstance.mint(alice, 123);
        await shoalInstance.mint(bob, 456);
        await shoalInstance.mint(charlie, 765);

        const charlieShare = await shoalInstance.calculateShareOfTokens(charlie);

        assert.equal(
            569196,
            parseInt(charlieShare),
            "Bobs share is not equal to the expected amount"
        )
    });
});
