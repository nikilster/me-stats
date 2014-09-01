/*
    Index.js
    --------
    Load the statistics data file and output to the display.  
*/

var meStatsApp = angular.module('meStatsApp', []);

meStatsApp.controller('KeysTypedController', function($scope) {

    //Calculate the totals
    var numKeysTypedTotal = 0;
    var numKeysTypedToday = 0;
    var numKeysTypedLastHour = 0;
    var numKeysTypedLastMinute = 0;

    //Save for display
    $scope.keysTypedStatistics = {
        'keysTypedTotal': 1000,
        'keysTypedToday': 123,
        'keysTypedLastHour': 12,
        'keysTypedLastMinute': 1
    };
});