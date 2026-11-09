"""
Rate Limiter Utility - Shared rate limiting functionality
"""

import time
from datetime import datetime, timedelta


class RateLimiter:
    """
    Smart rate limiter with time-window-based request counting
    Tracks requests per minute and enforces limits with safety margins
    """

    def __init__(self):
        self.request_times = []  # List of request timestamps

    def can_make_request(self, requests_per_minute: int = 60) -> bool:
        """
        Check if we can make a request without exceeding rate limit

        Args:
            requests_per_minute: Maximum requests allowed per minute

        Returns:
            bool: True if request is allowed, False if rate limited
        """
        current_time = datetime.now()
        minute_ago = current_time - timedelta(minutes=1)

        # Remove requests older than 1 minute
        self.request_times = [t for t in self.request_times if t > minute_ago]

        # Check if we're under the limit
        return len(self.request_times) < requests_per_minute

    def wait_if_needed(self, requests_per_minute: int = 60, safety_margin: float = 0.8):
        """
        Wait if necessary to respect rate limits with safety margin

        Args:
            requests_per_minute: Maximum requests per minute
            safety_margin: Safety margin (0.8 = 80% of limit)
        """
        # Apply safety margin
        safe_requests_per_minute = int(requests_per_minute * safety_margin)

        current_time = datetime.now()
        minute_ago = current_time - timedelta(minutes=1)

        # Clean old requests
        self.request_times = [t for t in self.request_times if t > minute_ago]

        # If we're at or over the safe limit, wait
        if len(self.request_times) >= safe_requests_per_minute:
            # Find oldest request in current window
            if self.request_times:
                oldest_request = min(self.request_times)
                # Wait until oldest request is 1 minute old
                wait_time = 60 - (current_time - oldest_request).total_seconds()
                if wait_time > 0:
                    time.sleep(wait_time)

        # Record this request
        self.request_times.append(datetime.now())