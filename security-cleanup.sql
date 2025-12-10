-- ============================================
-- LMS Database Security Cleanup Script
-- Run this AFTER deploying to production
-- ============================================
-- Remove all temporary passwords (security risk!)
UPDATE users
SET temp_password = NULL
WHERE temp_password IS NOT NULL;
-- Verify cleanup
SELECT COUNT(*) as remaining_temp_passwords
FROM users
WHERE temp_password IS NOT NULL;
-- Show confirmation
SELECT 'Security cleanup completed!' as status;
