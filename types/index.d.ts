import { default as PostmanRemoteEvent } from "./RemoteEvent";
import { default as PostmanRemoteFunction } from "./RemoteFunction";

export const Touched: RBXScriptSignal;
export const Destroying: RBXScriptSignal;

export function addRemoteEvent(name: string): PostmanRemoteEvent;

export function addRemoteFunction(name: string): PostmanRemoteFunction;

export function getRemoteEvent(name: string): PostmanRemoteEvent;

export function getRemoteFunction(name: string): PostmanRemoteFunction;

export function waitForRemoteEvent(name: string, timeout?: number): Promise<PostmanRemoteEvent>;

export function waitForRemoteFunction(name: string, timeout?: number): Promise<PostmanRemoteFunction>;
