'use strict';

const { Contract } = require('fabric-contract-api');

const util = require('util');

class Test extends Contract{

    constructor(){
        super('org.track-covid.test');
    }
    async instantiate(ctx){
        console.log('Test net is up!!');
    }
}

module.exports = Test;