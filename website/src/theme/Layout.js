import React from 'react';
import Layout from '@theme-original/Layout';
import { Provider } from 'react-redux';
import store from '../store';

export default function LayoutWrapper(props) {
  return (
    <Provider store={store}>
      <Layout {...props} />
    </Provider>
  );
}
