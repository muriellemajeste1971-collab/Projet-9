trigger OrderTrigger on Order (before update, after update) {

    OrderTriggerHandler.run();
}