trigger AccountTrigger on Account (after update) {

    AccountTriggerHandler.run();

}