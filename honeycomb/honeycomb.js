import { HoneycombWebSDK, WebVitalsInstrumentation } from '@honeycombio/opentelemetry-web';
import { getWebAutoInstrumentations } from '@opentelemetry/auto-instrumentations-web';

const configDefaults = {
  ignoreNetworkEvents: true,
};

const sdk = new HoneycombWebSDK({
  apiKey: 'QliXW9F4wu0fxT0xksBebG',
  serviceName: 'caffeine-lang-website',
  instrumentations: [
    getWebAutoInstrumentations({
      '@opentelemetry/instrumentation-xml-http-request': configDefaults,
      '@opentelemetry/instrumentation-fetch': configDefaults,
      '@opentelemetry/instrumentation-document-load': configDefaults,
    }),
    new WebVitalsInstrumentation(),
  ],
});

sdk.start();
