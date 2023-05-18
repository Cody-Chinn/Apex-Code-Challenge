/**
 * Created by CodyChinn on 5/17/2023.
 */
@IsTest
private class ObjectRelationshipHelperTest {
    @IsTest
    static void testCreateChildWithObjectOne() {
        Object_1__c testObject1 = new Object_1__c(Name = 'Testing One');
        ObjectRelationshipHelper.createRelationships(testObject1);

        Object_2__c createdObject2 = [
                SELECT Name, extId__c, Object_1__c
                FROM Object_2__c
        ];

        System.assert(createdObject2.Object_1__c != null, 'Test on family creation with object 1 failed. ' +
                'Could not find an Object_2__c with Object 1 as its parent');
    }

    @IsTest
    static void testCreateGrandchildWithObjectOne() {
        Object_1__c testObject1 = new Object_1__c(Name = 'Testing One');
        ObjectRelationshipHelper.createRelationships(testObject1);

        Object_2__c createdObject2 = [
                SELECT Name, extId__c, Object_1__c,
                    (
                        SELECT Id, Name, extId__c
                        FROM Object_3s__r
                    )
                FROM Object_2__c
        ];

        System.assert(createdObject2.Object_1__c != null && createdObject2.Object_3s__r.size() == 1, 'Test on family creation with object 1 failed. ' +
                'Could not find an Object_3__c with Object_2__c as its parent and Object_1__c as its grandparent.');
    }

    @IsTest
    static void testCreateParentWithObjectTwo() {
        Object_2__c testObject2 = new Object_2__c(Name = 'Testing Two');
        ObjectRelationshipHelper.createRelationships(testObject2);

        Object_2__c updatedObject2 = [
                SELECT Name, extId__c, Object_1__c
                FROM Object_2__c
        ];

        System.assert(updatedObject2.Object_1__c != null, 'Test on family creation with object 2 failed. ' +
                'Could not find an Object_1__c parent to the initial Object 2. ');
    }

    @IsTest
    static void testCreateGrandchildWithObjectTwo() {
        Object_2__c testObject2 = new Object_2__c(Name = 'Testing Two');
        ObjectRelationshipHelper.createRelationships(testObject2);

        Object_2__c createdObject2 = [
                SELECT Name, extId__c, Object_1__c,
                (
                        SELECT Id, Name, extId__c
                        FROM Object_3s__r
                )
                FROM Object_2__c
        ];

        System.assert(createdObject2.Object_3s__r.size() == 1, 'Test on family creation with object 2 failed. ' +
                'Could not find an Object_3__c with Object_2__c as its parent. ');
    }

    @IsTest
    static void testCreateParentWithObjectThree() {
        Object_3__c testObject3 = new Object_3__c(Name = 'Testing Three');
        ObjectRelationshipHelper.createRelationships(testObject3);

        Object_3__c updatedObject3 = [
                SELECT Name, extId__c, Object_2__c
                FROM Object_3__c
                WHERE Name = :testObject3.Name
        ];

        System.assert(updatedObject3.Object_2__c != null, 'Test on family creation with object 3 failed. ' +
                'Could not find an Object_2__c parent to the initial Object 3. ');
    }

    @IsTest
    static void testCreateGrandparentWithObjectThree() {
        Object_3__c testObject3 = new Object_3__c(Name = 'Testing Three');
        ObjectRelationshipHelper.createRelationships(testObject3);

        Object_3__c updatedObject3 = [
                SELECT Name, extId__c, Object_2__r.Object_1__c
                FROM Object_3__c
                WHERE Name = :testObject3.Name
        ];

        System.assert(updatedObject3.Object_2__r.Object_1__c != null, 'Test on family creation with object 3 failed. ' +
                'Could not find an Object_1__c with Object_3__c as its grandchild.');
    }
}