({
    handleEditClick : function(component, event, helper) {
        /* setting isEdit property to true when edit button is clicked */
        component.set('v.isEdit', true);
    },

    handleSaveClick : function(component, event, helper) {
        // Fetching the editForm from the HTML and then
        // use submit() standard function on the form
        component.find("editForm").submit();
        /* setting isEdit property to true when edit button is clicked */
        component.set('v.isEdit', false);
    }
})
