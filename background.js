chrome.runtime.onInstalled.addListener(function () {
    // save {color: #3aa757} on local storage
    chrome.storage.sync.set({ color: '#3aa757' }, function () {
        console.log('The color is green.');
    });

    // Determining whether or not to enable the extension this time
    chrome.declarativeContent.onPageChanged.removeRules(undefined, function () {
        chrome.declarativeContent.onPageChanged.addRules([{
            conditions: [new chrome.declarativeContent.PageStateMatcher({
                pageUrl: { hostEquals: 'developer.chrome.com' },
            })
            ],
            actions: [new chrome.declarativeContent.ShowPageAction()]
        }]);
    });
});