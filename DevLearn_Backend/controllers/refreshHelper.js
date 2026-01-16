const RefreshTokens = require('../models/RefreshTokens');

async function upsertRefreshToken(userId, email, refreshToken) {
  const maxAttempts = 4;
  let lastErr = null;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {

      await RefreshTokens.replaceOne(
        { userId },
        { userId, email, refreshToken, createdAt: new Date() },
        { upsert: true }
      );
      return;
    } catch (err) {
      lastErr = err;
      if (err && err.code === 11000) {
   
        console.warn(`E11000 on refresh token upsert (attempt ${attempt}), cleaning conflicts and retrying`);
        try {
      
          await RefreshTokens.deleteMany({ $or: [ { refreshToken, userId: { $ne: userId } }, { email, userId: { $ne: userId } } ] });
        } catch (cleanupErr) {
          console.error('Cleanup error during refresh token upsert recovery', cleanupErr);
        }

    
        await new Promise(res => setTimeout(res, 50 + Math.floor(Math.random() * 150)));
        continue;
      }

      // For other errors, rethrow
      throw err;
    }
  }


  try {
    await RefreshTokens.deleteMany({ userId });
    await RefreshTokens.create({ userId, email, refreshToken });
    return;
  } catch (finalErr) {
    console.error('Final attempt failed for refresh token upsert', finalErr, 'lastErr:', lastErr);
    throw finalErr || lastErr;
  }
}

module.exports = { upsertRefreshToken };
