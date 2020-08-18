const Pool = artifacts.require("Pool");

const oneEther = web3.utils.toWei("1");
const twoEther = web3.utils.toWei("2");

contract("Pool", accounts => {
    const alice = accounts[0];
    const bob = accounts[1];

    let poolInstance;

    // Reset the contract each run
    beforeEach(async function () {
        return await Pool.new()
            .then(function (instance) {
                poolInstance = instance;
            });
    });

    // it("Should allow creation and retrieval of an article", async () => {
    //     await poolInstance.deposit({
    //         from: alice,
    //         value: oneEther
    //     }).catch(console.log);
    //
    //     // const article = await newsPayPerInstance.getArticle.call(1);
    //     // const {0: description, 1: cost} = article;
    //     //
    //     // assert.equal(
    //     //     description,
    //     //     articleDescription,
    //     //     "Description does not match"
    //     // );
    //     //
    //     // assert.equal(
    //     //     cost.toString(),
    //     //     oneEther,
    //     //     "Unable to find the price for the article"
    //     // );
    // });
    //
    // it("It should store multiple articles and return a list when queried", async () => {
    //     let articleDescription = "This is my article name";
    //
    //     await newsPayPerInstance.addArticle(
    //         articleDescription,
    //         oneEther,
    //         {from: alice}
    //     );
    //
    //     await newsPayPerInstance.addArticle(
    //         articleDescription,
    //         oneEther,
    //         {from: alice}
    //     );
    //
    //     await newsPayPerInstance.addArticle(
    //         articleDescription,
    //         twoEther,
    //         {from: alice}
    //     );
    //
    //     const articles = await newsPayPerInstance.getArticles.call();
    //
    //     assert.equal(
    //         articles.length,
    //         3,
    //         "Total number of articles does not match total saved"
    //     );
    // });
    //
    // it("Should allow a wallet to purchase an article", async () => {
    //     let articleDescription = "This is my article name";
    //
    //     await newsPayPerInstance.addArticle(
    //         articleDescription,
    //         oneEther,
    //         {from: alice}
    //     );
    //
    //     await newsPayPerInstance.purchaseArticle(
    //         1,
    //         {
    //             value: oneEther,
    //             from: bob
    //         }
    //     );
    //
    //     await newsPayPerInstance.hasArticle(
    //         1,
    //         {from: alice}
    //     ).then(hasArticle => assert.equal(
    //         false,
    //         hasArticle,
    //         "Alice has not purchased the article but owns it"
    //     ));
    //
    //     await newsPayPerInstance.hasArticle(
    //         1,
    //         {from: bob}
    //     ).then(hasArticle => assert.ok(
    //         hasArticle,
    //         "Bob has purchased the article but does not own it"
    //     ));
    // });
    //
    // it("Should purchase only the selected article", async () => {
    //     let articleDescription = "This is my article name";
    //
    //     await newsPayPerInstance.addArticle(
    //         articleDescription,
    //         oneEther,
    //         {from: alice}
    //     );
    //
    //     await newsPayPerInstance.purchaseArticle(
    //         1,
    //         {
    //             value: oneEther,
    //             from: bob
    //         }
    //     );
    //
    //     await newsPayPerInstance.hasArticle(
    //         2,
    //         {from: bob}
    //     ).then(hasArticle => assert.equal(
    //         false,
    //         hasArticle,
    //         "Bob has not purchased the article but owns it"
    //     ));
    // });
    //
    // it("Should should not allow you to purchase the same article twice", async () => {
    //     let articleDescription = "This is my article name";
    //
    //     await newsPayPerInstance.addArticle(
    //         articleDescription,
    //         oneEther,
    //         {from: alice}
    //     );
    //
    //     await newsPayPerInstance.purchaseArticle(
    //         1,
    //         {
    //             value: oneEther,
    //             from: bob
    //         }
    //     );
    //
    //     try {
    //         await newsPayPerInstance.purchaseArticle(
    //             1,
    //             {
    //                 value: oneEther,
    //                 from: bob
    //             }
    //         );
    //     } catch (exception) {
    //         assert.ok(true)
    //         return
    //     }
    //
    //     assert.ok(false, "No exception thrown when trying to purchase same article twice")
    //
    //
    // });
});