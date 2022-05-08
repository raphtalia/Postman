/* eslint-disable @typescript-eslint/explicit-module-boundary-types */

export default class RemoteFunction {
	public Invoke(...args: any): any;
	public Invoke(player: Player, ...args: any): any;

	public Bind(callback: Callback): RemoteFunction;
}
