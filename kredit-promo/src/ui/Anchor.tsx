import type {Anchor as A} from '../world/layout';

/** Блок, привязанный к точке экрана (px) — см. Anchor в world/layout.ts. */
export const Anchor: React.FC<Partial<A> & {x: number; y: number; children: React.ReactNode}> = ({
	x,
	y,
	ax = 0.5,
	ay = 0.5,
	children,
}) => (
	<div
		style={{
			position: 'absolute',
			left: x,
			top: y,
			transform: `translate(${-ax * 100}%, ${-ay * 100}%)`,
		}}
	>
		{children}
	</div>
);
