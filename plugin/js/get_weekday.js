
/*jslint node: true, nomen: true, indent: 4, maxlen: 80, plusplus: true, sloppy: true, regexp: true */


(function () {
    'use strict';
    // 2012-04-18
    var date = process.argv[2],
        objDate;
    try {
        date = date.split('-');
    } catch (ex) {
        return console.log('ERROR');
    }
    if (!date || date.length !== 3) {
        return console.log('ERROR');
    }
    try {
        objDate = new Date(parseInt(date[0], 10), parseInt(date[1], 10) - 1,
                parseInt(date[2], 10));
    } catch (ex2) {
        return console.log('ERROR');
    }
    // 0 - 6
    return console.log(objDate.getDay());
}).call(this);
