/// Build-time feature policy, not a driving-state check. AAOS controls when
/// this parked-only preview may be shown; no user setting enables media.
const isParkedAutomotive = bool.fromEnvironment('ARES_PARKED_AUTOMOTIVE');
