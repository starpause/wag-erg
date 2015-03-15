# APK signing #

To deploy, the APK needs to be signed. For development, a self-signed certification is sufficient. The Air SDK has a tool for creating a self-signed certificate. The command line is:

adt –certificate -validityPeriod 25 -cn SelfSigned 1024-RSA sampleCert.p12 samplePassword