trigger OrderTrigger on Order (before update) {

    OrderTriggerHandler.run();
}