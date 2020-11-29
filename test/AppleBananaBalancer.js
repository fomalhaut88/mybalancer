const AppleBananaBalancer = artifacts.require("AppleBananaBalancer")

contract("AppleBananaBalancer", (accounts) => {
    let [alice, bob] = accounts
    let contractInstance

    beforeEach(async () => {
        contractInstance = await AppleBananaBalancer.new()

        let value = 0
        value = (await contractInstance.estimateChargeApple(25)).toNumber()
        await contractInstance.chargeApple(25, {from: alice, value: value})

        value = (await contractInstance.estimateChargeBanana(50)).toNumber()
        await contractInstance.chargeBanana(50, {from: alice, value: value})

        value = (await contractInstance.estimateChargeBanana(31)).toNumber()
        await contractInstance.chargeBanana(31, {from: bob, value: value})
    })

    it("Test Basic", async () => {
        const apple = await contractInstance.getApple({from: alice})
        assert.equal(apple, 25)

        const banana = await contractInstance.getBanana({from: alice})
        assert.equal(banana, 50)

        const totalApple = await contractInstance.getTotalApple({from: alice})
        assert.equal(totalApple, 25)

        const totalBanana = await contractInstance.getTotalBanana({from: alice})
        assert.equal(totalBanana, 81)

        const capitalization = await contractInstance.getCapitalization({from: alice})
        assert.equal(capitalization, 45000000000000)
    })

    it("Test Charge", async () => {
        const balanceOld = await web3.eth.getBalance(bob)

        const apple = 15

        const bobAppleOld = (await contractInstance.getApple({from: bob})).toNumber()
        const totalAppleOld = (await contractInstance.getTotalApple({from: bob})).toNumber()

        const appleValue = (await contractInstance.estimateChargeApple(apple, {from: bob})).toNumber()
        await contractInstance.chargeApple(apple, {from: bob, value: appleValue})

        const bobAppleNew = (await contractInstance.getApple({from: bob})).toNumber()
        const totalAppleNew = (await contractInstance.getTotalApple({from: bob})).toNumber()

        const balanceNew = await web3.eth.getBalance(bob)

        assert.equal(bobAppleNew, bobAppleOld + apple)
        assert.equal(totalAppleNew, totalAppleOld + apple)

        // console.log(balanceOld, balanceNew, appleValue)
        assert.ok(balanceNew < balanceOld)
    })

    it("Test Withdraw", async () => {
        const balanceOld = await web3.eth.getBalance(bob)

        const banana = 15

        const bobBananaOld = (await contractInstance.getBanana({from: bob})).toNumber()
        const totalBananaOld = (await contractInstance.getTotalBanana({from: bob})).toNumber()

        const bananaValue = (await contractInstance.estimateWithdrawBanana(banana, {from: bob})).toNumber()
        await contractInstance.withdrawBanana(banana, {from: bob, value: 0})

        const bobBananaNew = (await contractInstance.getBanana({from: bob})).toNumber()
        const totalBananaNew = (await contractInstance.getTotalBanana({from: bob})).toNumber()

        const balanceNew = await web3.eth.getBalance(bob)

        assert.equal(bobBananaNew, bobBananaOld - banana)
        assert.equal(totalBananaNew, totalBananaOld - banana)

        // console.log(balanceOld, balanceNew, bananaValue)
        // assert.ok(balanceNew > balanceOld)
    })

    it("Test Exchange", async () => {
        const banana = 11

        const bobAppleOld = (await contractInstance.getApple({from: bob})).toNumber()
        const bobBananaOld = (await contractInstance.getBanana({from: bob})).toNumber()

        const apple = (await contractInstance.estimateAppleForBanana(banana, {from: bob})).toNumber()
        assert.ok(apple > 0)

        await contractInstance.exchangeBananaForApple(banana, {from: bob, value: 0})

        const bobAppleNew = (await contractInstance.getApple({from: bob})).toNumber()
        const bobBananaNew = (await contractInstance.getBanana({from: bob})).toNumber()

        assert.equal(bobAppleNew, bobAppleOld + apple)
        assert.equal(bobBananaNew, bobBananaOld - banana)
    })
})
