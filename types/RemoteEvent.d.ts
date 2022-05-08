/* eslint-disable @typescript-eslint/explicit-module-boundary-types */

export default class RemoteEvent {
	public Fire(...args: any): void;
	public Fire(player: Player, ...args: any): void;

	public FireNearby(pos: Vector3, radius: number, ...args: any): void;

	public FireAll(...args: any): void;

	public Connect(handler: Callback): RBXScriptConnection;
}
