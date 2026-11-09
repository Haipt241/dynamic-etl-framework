-- SQL Commands to Grant KILL Permissions to etaniadmin
-- Run these commands as a user with GRANT privileges (like root/admin)
-- ======================================================================

-- Grant PROCESS privilege (to see all processes)
GRANT PROCESS ON *.* TO 'etaniadmin'@'%';

-- Grant SUPER privilege (to kill other users' processes)
GRANT SUPER ON *.* TO 'etaniadmin'@'%';

-- Flush privileges
FLUSH PRIVILEGES;

-- ======================================================================

-- ALTERNATIVE (for MySQL 8.0+):
GRANT CONNECTION_ADMIN ON *.* TO 'etaniadmin'@'%';
FLUSH PRIVILEGES;
