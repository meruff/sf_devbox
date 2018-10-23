/*****************************************
* File: NewCaseListController
* Author: Mathew Ruff, Sierra-Cedar
* Description: 
******************************************/
public class NewCaseListController {
    public List<Case> getNewCases() {
        return [
            SELECT Id, CaseNumber
            FROM Case
            WHERE Status = 'New'
        ];
    }
}