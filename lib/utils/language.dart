class Language {
  // Common
  String get cancel => 'Cancel';
  String get submit => 'Submit';
  String get update => 'Update';
  String get delete => 'Delete';
  String get edit => 'Edit';
  String get ok => 'OK';
  String get days => 'days';
  String get status => 'Status';
  String get type => 'Type';
  String get reason => 'Reason';
  String get fromDate => 'From Date';
  String get toDate => 'To Date';
  String get active => 'Active';
  String get inactive => 'Inactive';
  String get paid => 'Paid';
  String get unpaid => 'Unpaid';
  String get disabled => 'Disabled';
  String get total => 'Total';
  String get used => 'Used';
  String get remaining => 'Remaining';
  String get customPolicy => 'Custom Policy';
  String get shift => 'Shift';
  String get shifts => 'Shifts';
  String get addShift => 'Add Shift';
  String get editShift => 'Edit Shift';
  String get deleteShift => 'Delete Shift';
  String get noShiftsScheduled => 'No shifts scheduled';
  String get pleaseSelectDate => 'Please select a date';
  String get pleaseSelectTime => 'Please select a time';
  String get pleaseSelectBranch => 'Please select a branch';
  String get pleaseSelectUser => 'Please select a user';
  String get pleaseEnterTitle => 'Please enter a title';
  String get pleaseEnterDescription => 'Please enter a description';
  String get areYouSureDeleteShift =>
      'Are you sure you want to delete this shift?';
  String get shiftAddedSuccessfully => 'Shift added successfully';
  String get shiftUpdatedSuccessfully => 'Shift updated successfully';
  String get shiftDeletedSuccessfully => 'Shift deleted successfully';
  String get failedToAddShift => 'Failed to add shift';
  String get failedToUpdateShift => 'Failed to update shift';
  String get failedToDeleteShift => 'Failed to delete shift';
  String get failedToFetchShifts => 'Failed to fetch shifts';
  String get getShiftsError => 'getShifts Error: ';
  String get addShiftError => 'addShift Error: ';
  String get updateShiftError => 'updateShift Error: ';
  String get deleteShiftError => 'deleteShift Error: ';

  // Leave specific
  String get leaves => 'Leaves';
  String get leaveTypes => 'Leave Types';
  String get leaveType => 'Leave Type';
  String get leaveHistory => 'Leave History';
  String get requestLeave => 'Request Leave';
  String get editLeave => 'Edit Leave';
  String get deleteLeave => 'Delete Leave';
  String get noLeavesScheduled => 'No leaves scheduled';
  String get noEnabledLeaveTypes => 'No enabled leave types available';
  String get leaveTypeDisabled => 'This leave type is disabled';
  String get pleaseSelectLeaveType => 'Please select a leave type';
  String get pleaseSelectFromDate => 'Please select from date';
  String get pleaseSelectToDate => 'Please select to date';
  String get areYouSureDeleteLeave =>
      'Are you sure you want to delete this leave?';
  String get leaveAddedSuccessfully => 'Leave added successfully';
  String get leaveUpdatedSuccessfully => 'Leave updated successfully';
  String get leaveDeletedSuccessfully => 'Leave deleted successfully';
  String get failedToAddLeave => 'Failed to add leave';
  String get failedToUpdateLeave => 'Failed to update leave';
  String get failedToDeleteLeave => 'Failed to delete leave';
  String get failedToFetchLeaves => 'Failed to fetch leaves';
  String get getLeavesError => 'getLeaves Error: ';
  String get addLeaveError => 'addLeave Error: ';
  String get updateLeaveError => 'updateLeave Error: ';
  String get deleteLeaveError => 'deleteLeave Error: ';
  String get cannotEditPastLeaves => 'Cannot edit past leaves';

  // Leave management
  String get enterReason => 'Please enter a reason';
  String get leaveSettings => 'Leave Settings';
  String get leavePolicies => 'Leave Policies';
  String get addLeavePolicy => 'Add Leave Policy';
  String get editLeavePolicy => 'Edit Leave Policy';
  String get deleteLeavePolicy => 'Delete Leave Policy';
  String get policyName => 'Policy Name';
  String get policyDescription => 'Policy Description';
  String get annualLeave => 'Annual Leave';
  String get sickLeave => 'Sick Leave';
  String get personalLeave => 'Personal Leave';
  String get maternityLeave => 'Maternity Leave';
  String get paternityLeave => 'Paternity Leave';
  String get bereavementLeave => 'Bereavement Leave';
  String get otherLeave => 'Other Leave';
  String get leaveBalance => 'Leave Balance';
  String get leaveRequests => 'Leave Requests';
  String get pendingRequests => 'Pending Requests';
  String get approvedRequests => 'Approved Requests';
  String get rejectedRequests => 'Rejected Requests';
  String get requestStatus => 'Request Status';
  String get requestDate => 'Request Date';
  String get approvedBy => 'Approved By';
  String get approvalDate => 'Approval Date';
  String get comments => 'Comments';
  String get attachments => 'Attachments';
  String get addAttachment => 'Add Attachment';
  String get removeAttachment => 'Remove Attachment';
  String get submitRequest => 'Submit Request';
  String get cancelRequest => 'Cancel Request';
  String get approveRequest => 'Approve Request';
  String get rejectRequest => 'Reject Request';
  String get requestSubmitted => 'Request submitted successfully';
  String get requestCancelled => 'Request cancelled successfully';
  String get requestApproved => 'Request approved successfully';
  String get requestRejected => 'Request rejected successfully';
  String get failedToSubmitRequest => 'Failed to submit request';
  String get failedToCancelRequest => 'Failed to cancel request';
  String get failedToApproveRequest => 'Failed to approve request';
  String get failedToRejectRequest => 'Failed to reject request';
}

final language = Language();
