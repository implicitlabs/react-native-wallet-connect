import { PropTypes } from "prop-types";
import React, { Component } from "react";
import {
  NativeModules,
  NativeEventEmitter,
  requireNativeComponent,
  ViewPropTypes
} from "react-native";

const ReactNativeWalletConnect = NativeModules.ReactNativeWalletConnect;
const setModelHeight = model_height_value => {
  return ReactNativeWalletConnect.setModelHeight(model_height_value);
};

export { setModelHeight };
