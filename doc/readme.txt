### To-Dos

- Parse response to decode bitfields
- Make response wrapper useful to users of this library
- Limit Exceeded/Manager Needed overrides
- Confirm decline behaviour
- Re-presented checks
- Voids
- Certification


### Application Processing

New Merchant Application XSD is https://demo.eftchecks.com/webservices/Schemas/App/NewMerchApp_ACH.xsd

Sample data is https://demo.eftchecks.com/webservices/Schemas/App/Example/NewMerchAppSample_ACH.xml



### Implementation Notes

Useful information received from our integration specialist at GETI that's not clear from their PDF documentation.

#### SEC Code

The SEC code is not determined by the type of services you offer, it is determined by how you receive payment.

- PPD - Authorization is made in person and Merchant initiates transaction at a later time.  A check is not present. 
- CCD - Authorization is made between two companies to transfer funds. 
- POP - Payment is made in person at the point of sale.
- TEL - Payment is made by phone or fax.  A check is not present. 
- WEB - Payment is made through the internet.  A check is not present. 
 
The DL Requirement, Check Verification and Identity Verification are turned on or off for each merchant based on their risk.  This is decided during merchant underwriting and is not determined by the gateway.  For this reason you want to test against all terminal ids related to the transaction types you are processing. 

#### Processing Delays

The SOAP API gives realtime Approved/Declined responses, however transactions are not processed until the next business day. This contrasts with bulk upload of transactions via FTP, which will process same day if uploaded before noon CST.
