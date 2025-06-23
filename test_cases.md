This document outlines 40 automation test cases for a hypothetical SMTP (Simple Mail Transfer Protocol) service. These test cases cover various aspects of email sending, connection handling, authentication, and error scenarios.
## Assumptions for the Service:
* Standard Ports: SMTP (25), SMTPS (465), Submission (587).
* Authentication: Supports common methods like PLAIN, LOGIN.
* TLS/SSL: Supports secure connections over TLS/SSL.
* Error Handling: Returns appropriate SMTP response codes (2xx, 3xx, 4xx, 5xx) and descriptive messages.
* Test Environment: A controlled environment where server configurations (e.g., authentication requirements, relaying, user accounts, blacklists) can be manipulated for testing purposes.
## Category 1: Connection and Basic Handshake
### 1. TC001: Successful Connection to Standard SMTP Port (25)
* Description: Verify a successful connection can be established to the default SMTP port.
* Steps:
1. Initialize a network socket.
2. Attempt to establish a TCP connection to smtp.example.com.
3. Specify port 25 for the connection.
4. Wait for the server's initial greeting.
5. Verify the connection status.
* Expected Result: Server responds with a 220 service ready greeting.

### 2. TC002: Successful Connection to Submission Port (587) with STARTTLS
o Description: Verify a successful connection and initiation of TLS on the submission port.
o Steps:
1. Establish a TCP connection to smtp.example.com on port 587.
2. Send the EHLO example.com command.
3. Send the STARTTLS command.
4. Initiate the TLS handshake over the existing connection.
5. Verify the successful completion of the TLS handshake.
o Expected Result: Server responds with 220 after initial connection, 250 after EHLO, and 220 after STARTTLS, followed by successful TLS handshake.

### 4. TC003: Successful Connection to SMTPS Port (465)
o Description: Verify a successful implicit TLS connection to the SMTPS port.
o Steps:
1. Initialize a TLS-enabled network socket.
2. Attempt to establish an encrypted TCP connection to smtp.example.com.
3. Specify port 465 for the connection.
4. Perform the TLS handshake implicitly.
5. Wait for and receive the server's initial greeting over the encrypted channel.
o Expected Result: Server responds with a 220 greeting over the encrypted channel.
### 4. TC004: Connection to Invalid Port
o Description: Verify that connecting to a non-SMTP port results in a connection refusal or timeout.
o Steps:
1. Initialize a network socket.
2. Attempt to establish a TCP connection to smtp.example.com.
3. Specify a known unused port (e.g., 9999).
4. Set a reasonable connection timeout.
5. Observe the connection attempt outcome.
o Expected Result: Connection refused or connection timeout.
### 5. TC005: Incomplete Connection (Drop Connection After Greeting)
o Description: Verify server behavior when client drops connection after greeting.
o Steps:
1. Establish a TCP connection to the SMTP server.
2. Receive the 220 service ready greeting.
3. Immediately send a connection close signal (e.g., socket.close()).
4. Do not send any further SMTP commands.
5. Monitor server logs for connection handling.
o Expected Result: Server logs show connection closed by client; no errors or resource leaks on the server.
### 6. TC031: Concurrent Connections (Multiple Simultaneous Valid Connections)
o Description: Verify the SMTP server can handle multiple concurrent, valid client connections without errors or performance degradation.
o Steps:
1. Create a test script to initiate multiple client processes or threads.
2. Simultaneously establish 50-100 independent TCP connections to the SMTP server (e.g., on port 25 or 587).
3. For each connection, perform a basic EHLO command.
4. Monitor the response time for each EHLO.
5. Verify server resource utilization (CPU, memory) during the test.
o Expected Result: All connections are successfully established, and all EHLO commands receive a 250 OK response within acceptable latency. Server resources (CPU, memory) remain within acceptable limits.
### 7. TC032: Connection Rate Limit Exceeded
o Description: Verify the server correctly enforces connection rate limits, if configured, by rejecting excessive connection attempts from a single IP.
o Steps:
1. Configure the SMTP server with a strict connection rate limit for a source IP.
2. From a single source IP, rapidly attempt to establish a very high number of TCP connections (e.g., 500 connections in 10 seconds).
3. Monitor the response of each connection attempt after the initial successful ones.
4. Check for connection refused errors or timeouts.
5. Review server logs for rate limiting messages.
o Expected Result: After a certain threshold, subsequent connection attempts are actively refused by the server (e.g., TCP RST) or time out, and the server logs indicate rate limiting.
## Category 2: Authentication
### 8. TC006: Successful Authentication (AUTH PLAIN)
o Description: Verify that a client can successfully authenticate using the PLAIN mechanism.
o Steps:
1. Establish a connection to the SMTP server.
2. Send the EHLO example.com command and receive capabilities.
3. Send the AUTH PLAIN command with a base64 encoded valid username and password (e.g., \0username\0password).
4. Receive the server's authentication response.
5. Verify the authentication status code.
o Expected Result: Server responds with 235 Authentication successful.
### 9. TC007: Successful Authentication (AUTH LOGIN)
o Description: Verify that a client can successfully authenticate using the LOGIN mechanism.
o Steps:
1. Establish a connection to the SMTP server.
2. Send the EHLO example.com command and receive capabilities.
3. Send the AUTH LOGIN command.
4. Send the base64 encoded username when prompted by the server (334 response).
5. Send the base64 encoded password when prompted by the server (334 response).
o Expected Result: Server responds with 235 Authentication successful.
### 10. TC008: Failed Authentication (Invalid Credentials)
o Description: Verify that authentication fails with incorrect username or password.
o Steps:
1. Establish a connection to the SMTP server.
2. Send the EHLO example.com command.
3. Attempt AUTH PLAIN or AUTH LOGIN.
4. Provide incorrect (invalid) credentials.
5. Observe the server's response code for authentication.
o Expected Result: Server responds with 535 5.7.8 Authentication credentials invalid or similar error.
### 11. TC009: Failed Authentication (Missing Credentials)
o Description: Verify that authentication fails with missing credentials.
o Steps:
1. Establish a connection to the SMTP server.
2. Send the EHLO example.com command.
3. Attempt AUTH PLAIN or AUTH LOGIN.
4. Provide empty or incomplete (e.g., only username, no password) credentials.
5. Observe the server's response code.
o Expected Result: Server responds with 501 Syntax error or 535 Authentication credentials invalid.
### 12. TC010: Authentication Required for Relaying (Unauthenticated Attempt)
o Description: Verify that the server rejects an unauthenticated attempt to relay mail if authentication is required.
o Steps:
1. Establish a TCP connection to the SMTP server.
2. Send the EHLO example.com command.
3. Send MAIL FROM:<user@yourdomain.com>.
4. Send RCPT TO:<external@otherdomain.com> (an external domain).
5. Do NOT perform any AUTH command before MAIL FROM.
o Expected Result: Server responds with 550 5.7.1 Relaying denied or 530 5.7.0 Authentication required for the RCPT TO command.
## Category 3: Email Sending - Valid Scenarios
### 13. TC011: Send Simple Email to Single Recipient
o Description: Verify sending a basic email with valid MAIL FROM, RCPT TO, DATA.
o Steps:
1. Connect and authenticate successfully.
2. Send MAIL FROM:<sender@yourdomain.com>.
3. Send RCPT TO:<recipient@yourdomain.com>.
4. Send the DATA command, followed by minimal headers and body content.
5. Terminate the email content with a single dot (.) on a new line.
o Expected Result: Server responds with 250 OK for MAIL FROM and RCPT TO, 354 Start mail input, and 250 OK after .. Recipient receives the email.
### 14. TC012: Send Email to Multiple Recipients
o Description: Verify sending an email to multiple valid recipients.
o Steps:
1. Connect and authenticate successfully.
2. Send MAIL FROM:<sender@yourdomain.com>.
3. Send multiple RCPT TO commands for different valid recipients.
4. Send the DATA command, followed by email body.
5. Terminate the email content with a single dot (.) on a new line.
o Expected Result: All RCPT TO commands return 250 OK. All recipients receive the email.
### 15. TC013: Send Email with UTF-8 Characters in Subject/Body
o Description: Verify that the server handles UTF-8 encoded characters correctly.
o Steps:
1. Connect and authenticate successfully.
2. Initiate a mail transaction (MAIL FROM, RCPT TO).
3. Send DATA with email headers containing Subject: =?UTF-8?B?2LXYsdipINio2LHZhSDYqNin2LHYqQ==?= (Base64 encoded "Hello World" in Arabic).
4. Include a body with non-ASCII UTF-8 text (e.g., "???????" for "Hello World" in Japanese).
5. Terminate the email with ..
o Expected Result: Recipient receives the email with correctly displayed UTF-8 characters in both subject and body.
### 16. TC014: Send Email with Large Body (e.g., 1MB)
o Description: Verify the server's ability to handle emails with large content.
o Steps:
1. Connect and authenticate successfully.
2. Initiate a mail transaction (MAIL FROM, RCPT TO).
3. Send the DATA command.
4. Generate and send an email body of approximately 1MB of textual content (e.g., repeated lines of dummy text).
5. Terminate the email content with a single dot (.) on a new line.
o Expected Result: Server accepts the email (250 OK after .), and the recipient receives the full content without truncation or corruption.
### 17. TC015: Send Email with No Body (Headers Only)
o Description: Verify sending an email that consists only of headers and no body content.
o Steps:
1. Connect and authenticate successfully.
2. Initiate a mail transaction (MAIL FROM, RCPT TO).
3. Send the DATA command.
4. Send only essential headers (e.g., From:, To:, Subject:) and an empty line to separate headers from body.
5. Immediately terminate the email with a single dot (.) on a new line.
o Expected Result: Server accepts the email. Recipient receives an email with headers but an empty body.
### 18. TC033: Send Email with Attachments (Base64 Encoded)
o Description: Verify the server can properly handle emails with base64 encoded attachments.
o Steps:
1. Connect and authenticate successfully.
2. Initiate a mail transaction (MAIL FROM, RCPT TO).
3. Construct a multi-part MIME email message.
4. Include a small base64-encoded attachment (e.g., a text file or small image) within the MIME structure.
5. Send the entire MIME message via the DATA command, followed by ..
o Expected Result: Server accepts the email. The recipient receives the email, and the attachment is correctly decoded and accessible.
## Category 4: Email Sending - Invalid/Edge Scenarios
### 19. TC016: Invalid MAIL FROM Format
o Description: Verify server rejects malformed MAIL FROM addresses.
o Steps:
1. Connect and authenticate successfully (if required).
2. Send the EHLO example.com command.
3. Attempt to send a MAIL FROM command with a clearly invalid email address format (e.g., MAIL FROM:<invalid-email>).
4. Observe the server's response.
5. Ensure no subsequent commands are accepted after the rejection.
o Expected Result: Server responds with 501 Syntax error in parameters or arguments.
### 20. TC017: Invalid RCPT TO Format
o Description: Verify server rejects malformed RCPT TO addresses.
o Steps:
1. Connect and authenticate successfully.
2. Send a valid MAIL FROM command.
3. Attempt to send a RCPT TO command with a clearly invalid email address format (e.g., RCPT TO:<invalid-email>).
4. Observe the server's response.
5. Ensure the transaction state is not corrupted.
o Expected Result: Server responds with 501 Syntax error in parameters or arguments.
### 21. TC018: Non-Existent RCPT TO Domain
o Description: Verify server handles recipients with non-existent domains gracefully.
o Steps:
1. Connect and authenticate successfully.
2. Send a valid MAIL FROM command.
3. Send RCPT TO:<user@nonexistentdomain12345.com> where the domain does not resolve via DNS.
4. Observe the server's response to the RCPT TO command.
5. Attempt to proceed with DATA (which should be rejected or result in a bounce).
o Expected Result: Server responds with 550 5.1.2 Bad destination system address or 554 5.4.4 Host not found for the RCPT TO command.
### 22. TC019: MAIL FROM After DATA Command
o Description: Verify that the server correctly rejects commands after DATA has been initiated.
o Steps:
1. Connect and authenticate successfully.
2. Send valid MAIL FROM and RCPT TO commands.
3. Send the DATA command.
4. Before sending the . termination, attempt to send another MAIL FROM command.
5. Observe the server's response to the second MAIL FROM.
o Expected Result: Server responds with 503 Bad sequence of commands.
### 23. TC020: RCPT TO Without Prior MAIL FROM
o Description: Verify that RCPT TO is rejected if MAIL FROM has not been sent.
o Steps:
1. Connect to the SMTP server.
2. Send the EHLO example.com command.
3. Attempt to send a RCPT TO:<recipient@example.com> command.
4. Do not send a MAIL FROM command beforehand.
5. Observe the server's response.
o Expected Result: Server responds with 503 Bad sequence of commands.
### 24. TC021: Sending DATA Without RCPT TO
o Description: Verify that DATA is rejected if no valid recipients have been specified.
o Steps:
1. Connect to the SMTP server and authenticate.
2. Send EHLO example.com.
3. Send MAIL FROM:<sender@example.com>.
4. Do NOT send any RCPT TO commands.
5. Attempt to send the DATA command.
o Expected Result: Server responds with 554 5.5.1 Error: no valid recipients or similar.
### 25. TC022: Exceeding Maximum RCPT TO Limit (if applicable)
o Description: Verify the server enforces a maximum recipient limit per transaction.
o Steps:
1. Configure the SMTP server with a known maximum RCPT TO limit (e.g., 50).
2. Connect and authenticate.
3. Send MAIL FROM.
4. Send RCPT TO commands for more recipients than the configured limit (e.g., 51 valid recipients).
5. Observe the server's response to the RCPT TO command that exceeds the limit.
o Expected Result: Server responds with 452 4.5.3 Too many recipients or 552 5.3.4 Message size exceeds fixed maximum message size (if limit is related to size).
### 26. TC034: Invalid Email Address in DATA Body (e.g., in a From: header)
o Description: Verify that an invalid From: address within the email headers in the DATA stream (not the MAIL FROM command) doesn't cause a server crash or unexpected behavior.
o Steps:
1. Connect, authenticate, and initiate a valid mail transaction (MAIL FROM, RCPT TO).
2. Send the DATA command.
3. In the email headers part of the DATA stream, include a From: header with a syntactically invalid email address (e.g., From: <malformed_address@>).
4. Send valid body content and terminate with ..
5. Verify the server accepts the email and does not crash.
o Expected Result: Server accepts the mail (as the MAIL FROM was valid), and ideally, the recipient's mail client might show a warning, but the SMTP server itself should not error out.
### 27. TC035: Missing Dot Termination for DATA (Client drops connection)
o Description: Verify server behavior when the client drops the connection after sending DATA but without sending the . termination.
o Steps:
1. Connect and authenticate successfully.
2. Send valid MAIL FROM and RCPT TO.
3. Send the DATA command and send some body content.
4. Immediately close the socket (e.g., socket.close()) without sending the termination dot (.).
5. Monitor server logs for incomplete transaction handling and verify non-delivery.
o Expected Result: Server logs show connection closed by client, and the partial email is not delivered. Server should clean up resources and not crash.
### 28. TC036: Attempt to send DATA with just a dot on a line (without dot-stuffing)
o Description: Verify the server's handling of a . character at the beginning of a line within the DATA stream without proper dot-stuffing.
o Steps:
1. Connect and authenticate successfully.
2. Send valid MAIL FROM and RCPT TO.
3. Send the DATA command.
4. Send a line of text, then a new line containing only a single dot (.).
5. Send another line of text immediately after the single dot.
o Expected Result: Server should interpret the lone dot as the end of the DATA stream and close the DATA phase, potentially leading to an incomplete message or error if the intent was more data. The server should not crash.
### 29. TC037: Sender Domain Does Not Exist (DNS Check)
o Description: Verify the server rejects MAIL FROM commands if it performs a reverse DNS lookup or checks for the existence of the sender's domain's MX records, and the domain doesn't exist.
o Steps:
1. Connect to the SMTP server.
2. Send the EHLO example.com command.
3. Attempt to send MAIL FROM:<user@nonexistent-sender-domain-12345.com> where nonexistent-sender-domain-12345.com has no valid DNS records.
4. Observe the server's response to the MAIL FROM command.
5. Verify the rejection is due to domain non-existence.
o Expected Result: Server responds with a 550 5.7.1 Sender domain not found or 451 4.4.1 DNS lookup failed.
## Category 5: SMTP Commands and Session Management
### 30. TC023: HELO Command (Legacy)
o Description: Verify the server responds correctly to the HELO command.
o Steps:
1. Establish a TCP connection to the SMTP server.
2. Send the HELO example.com command.
3. Receive the server's response to the HELO command.
4. Verify the response code is 250.
5. Confirm the server greeting in the response.
o Expected Result: Server responds with 250 greeting.
### 31. TC024: EHLO Command (Extended)
o Description: Verify the server responds correctly to EHLO and lists supported extensions.
o Steps:
1. Establish a TCP connection to the SMTP server.
2. Send the EHLO example.com command.
3. Receive the multi-line response from the server.
4. Verify the first line starts with 250-greeting.
5. Parse subsequent lines to confirm the presence of expected extensions (e.g., AUTH, SIZE, PIPELINING).
o Expected Result: Server responds with 250-greeting followed by a list of extensions (e.g., 250-AUTH, 250-SIZE, 250-PIPELINING, 250 HELP).
### 32. TC025: NOOP Command
o Description: Verify the server responds correctly to the NOOP command.
o Steps:
1. Establish a connection to the SMTP server.
2. Send the EHLO example.com command.
3. Send the NOOP command.
4. Receive the server's response to the NOOP command.
5. Verify the response code is 250.
o Expected Result: Server responds with 250 OK.
### 33. TC026: RSET Command (Reset Session)
o Description: Verify RSET resets the current mail transaction state.
o Steps:
1. Connect and authenticate successfully.
2. Send MAIL FROM:<sender@example.com>.
3. Send RCPT TO:<recipient@example.com>.
4. Send the RSET command.
5. Attempt to send the DATA command immediately after RSET (should fail as transaction is reset).
o Expected Result: Server responds with 250 OK to RSET. DATA attempt should fail with 554 5.5.1 Error: no valid recipients, indicating the transaction was reset.
### 34. TC027: QUIT Command
o Description: Verify that QUIT terminates the session cleanly.
o Steps:
1. Establish a connection to the SMTP server.
2. Send the EHLO example.com command.
3. Send the QUIT command.
4. Receive the server's graceful shutdown response.
5. Verify the TCP connection is closed by the server.
o Expected Result: Server responds with 221 Bye, and the connection is closed.
### 35. TC028: Invalid Command
o Description: Verify server rejects unrecognized or misspelled commands.
o Steps:
1. Establish a connection to the SMTP server.
2. Send the EHLO example.com command.
3. Send a completely invalid or misspelled command (e.g., INVALICOMMAND, FOO).
4. Observe the server's response to the invalid command.
5. Ensure the session remains stable.
o Expected Result: Server responds with 500 Syntax error, command unrecognized.
## Category 6: Security and Advanced Scenarios
### 36. TC029: Email from Blacklisted Sender (if applicable)
o Description: Verify that emails from blacklisted senders are rejected.
o Steps:
1. Configure the SMTP server to blacklist a specific sender email address (e.g., spam@example.net).
2. Establish a connection to the SMTP server.
3. Attempt to send mail using MAIL FROM:<spam@example.net>.
4. Observe the server's response to the MAIL FROM command.
5. Verify the rejection reason in the response.
o Expected Result: Server responds with 550 5.7.1 Sender policy rejected or similar error for the MAIL FROM command.
### 37. TC030: Max Line Length in DATA (e.g., 998 characters + CRLF)
o Description: Verify the server correctly handles lines exceeding the maximum recommended length in the DATA stream (excluding the dot-stuffing case).
o Steps:
1. Connect and authenticate.
2. Initiate a mail transaction (MAIL FROM, RCPT TO).
3. Send the DATA command.
4. Construct an email body containing a single line of text that is exactly 998 characters long.
5. Construct another line that is 999 characters long.
6. Send these lines, then terminate with ..
o Expected Result: Server accepts the email, or rejects with a specific error if it strictly enforces a shorter limit. (Ideally, it should accept per RFC 5321, but some MTAs might have stricter rules).
### 38. TC038: IP Address Blacklisting (Connection Rejection)
* Description: Verify that the server actively rejects connection attempts from IP addresses listed on its internal or external blacklists (e.g., DNSBLs).
* Steps:
1. Configure the SMTP server to use a test DNSBL or internal IP blacklist.
2. Obtain a known blacklisted IP address (for testing purposes).
3. Attempt to establish a TCP connection to the SMTP server from this blacklisted IP address.
4. Observe whether the connection is refused immediately or closed shortly after the greeting.
5. Verify server logs indicate the blacklisted IP and rejection.
* Expected Result: Connection is refused immediately, or the server closes the connection shortly after the greeting with a 554 5.7.1 Access denied or similar message, and logs indicate the blacklisted IP.
### 39. TC039: Header Injection Attempt (CRLF Injection)
* Description: Verify the server's robustness against CRLF (Carriage Return Line Feed) injection attempts in email headers during the DATA phase.
* Steps:
1. Connect, authenticate, and initiate a valid mail transaction (MAIL FROM, RCPT TO).
2. Send the DATA command.
3. In the header section, attempt to inject extra headers or break existing ones by inserting \r\n characters (e.g., Subject: Test\r\nBcc: evil@attacker.com).
4. Send the rest of the email body and terminate with ..
5. Verify that the injected headers are not parsed as valid separate headers by the server or recipient.
* Expected Result: The server should sanitize or reject the malformed headers, preventing the injection. The email should either be rejected or delivered with the injected characters escaped, not interpreted as new headers.
### 40. TC040: Reverse DNS Mismatch (PTR Record Check)
o Description: Verify that the SMTP server rejects incoming connections or mail from clients whose IP address does not have a valid, matching Reverse DNS (PTR) record.
o Steps:
1. Configure the SMTP server to perform PTR record checks for incoming connections.
2. Set up a test client IP address that either has no PTR record or a misconfigured one (does not resolve back to the original IP).
3. Attempt to establish a TCP connection and send mail from this test client IP.
4. Observe the server's response during connection or MAIL FROM phase.
5. Verify the rejection message.
o Expected Result: The server should respond with a 550 5.7.1 Client host rejected: cannot find your hostname or 450 4.7.1 Client host rejected: cannot find your hostname, depending on the server's policy.

