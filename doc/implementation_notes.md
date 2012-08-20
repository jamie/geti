Notes received from Brooklynne Rukse <brukse@globaletelecom.com> (our
technical contact) while planning for realtime integration.

> > 14 Aug, "RE: GETI Authorization Gateway Integration & Documentation"
> 
> The SEC code is not determined by the type of services you offer, it is determined by how you receive payment.  Please let me know which of the following applies to your business.
> 
> ·         PPD - Authorization is made in person and Merchant initiates transaction at a later time.  A check is not present. 
> ·         CCD - Authorization is made between two companies to transfer funds. 
> ·         POP - Payment is made in person at the point of sale.
> ·         TEL - Payment is made by phone or fax.  A check is not present. 
> ·         WEB - Payment is made through the internet.  A check is not present. 
>  
> The DL Requirement, Check Verification and Identity Verification are turned on or off for each merchant based on their risk.  This is decided during merchant underwriting and is not determined by the gateway.  For this reason you want to test against all terminal ids related to the transaction types you are processing. 

We're all online, so we'll be doing WEB. But, we should be handling all
verification cases as that determination is not in Geti's hands.

> > > 17 Aug, "RE: Certification Credentials for VersaPay"
> > 
> > The api gives real time responses (Approved/Declined) immediately however the transactions are not processed until the next business day.  Any file transactions that is submitted before Noon CST are processed the same day. 
> 
> [Jamie] Oh. So a transaction submitted Monday 8am via FTP goes through same day, but one submitted at the same time over SOAP isn't processed until Tuesday?
> 
> > That is correct

So doing batch file uploads will process (before noon) a day sooner or
(after noon) at the same time. We don't have any expectations regarding
realtime approval currently, so giving up on the realtime aspect makes sense.
