const AppleBananaBalancer = artifacts.require("AppleBananaBalancer")

contract("AppleBananaBalancer", (accounts) => {
    let [alice, bob] = accounts
    let contractInstance = null

    beforeEach(async () => {
        contractInstance = await AppleBananaBalancer.new()

        await contractInstance.charge({from: alice, value: web3.utils.toWei('700', 'micro')})
        await contractInstance.charge({from: bob, value: web3.utils.toWei('1300', 'micro')})
    })

    it("Test Basic", async () => {
        const totalApple = (await contractInstance.getTotalApple({from: alice})).toNumber()
        assert.equal(totalApple, 2000)

        const totalBanana = (await contractInstance.getTotalBanana({from: alice})).toNumber()
        assert.equal(totalBanana, 2000)

        const capitalization = (await contractInstance.getCapitalization({from: alice})).toNumber()
        assert.equal(capitalization, web3.utils.toWei('2000', 'micro'))
    })

    it("Test Charge", async () => {
        const balanceOld = await web3.eth.getBalance(bob)
        const appleOld = (await contractInstance.getTotalApple({from: bob})).toNumber()
        const capitalizationOld = (await contractInstance.getCapitalization({from: bob})).toNumber()

        const value = web3.utils.toWei('100', 'micro')
        await contractInstance.charge({from: bob, value: value})

        const balanceNew = await web3.eth.getBalance(bob)
        const appleNew = (await contractInstance.getTotalApple({from: bob})).toNumber()
        const capitalizationNew = (await contractInstance.getCapitalization({from: bob})).toNumber()

        assert.equal(capitalizationNew, capitalizationOld + parseInt(value))
        assert.equal(appleNew, appleOld + 100)
        assert.ok(balanceNew < balanceOld)
    })

    it("Test Withdraw", async () => {
        const balanceOld = await web3.eth.getBalance(bob)
        const appleOld = (await contractInstance.getTotalApple({from: bob})).toNumber()
        const capitalizationOld = (await contractInstance.getCapitalization({from: bob})).toNumber()

        const value = web3.utils.toWei('100', 'micro')
        await contractInstance.withdraw(value, {from: bob})

        const balanceNew = await web3.eth.getBalance(bob)
        const appleNew = (await contractInstance.getTotalApple({from: bob})).toNumber()
        const capitalizationNew = (await contractInstance.getCapitalization({from: bob})).toNumber()

        assert.equal(capitalizationNew, capitalizationOld - parseInt(value))
        assert.equal(appleNew, appleOld - 100)
        // assert.ok(balanceNew > balanceOld)
    })

    it("Test Exchange", async () => {
        const banana = 100

        const appleOld = (await contractInstance.getTotalApple({from: bob})).toNumber()
        const bananaOld = (await contractInstance.getTotalBanana({from: bob})).toNumber()

        const apple = (await contractInstance.estimateAppleInBanana(banana, {from: bob})).toNumber()
        assert.ok(apple > 0)

        const value = (await contractInstance.estimateValueOfBanana(banana, {from: bob})).toNumber()

        await contractInstance.exchangeBananaForApple(banana, {from: bob, value: value / 1000})

        const appleNew = (await contractInstance.getTotalApple({from: bob})).toNumber()
        const bananaNew = (await contractInstance.getTotalBanana({from: bob})).toNumber()

        assert.equal(appleNew, appleOld + apple)
        assert.equal(bananaNew, bananaOld - banana)
    })
})
