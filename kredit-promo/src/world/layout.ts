// Экранные точки привязки подписей (px). Чистые функции поверх formations.ts —
// используются оверлеями и scripts/check-layout.ts.
import {
	binTopY,
	binX,
	CHECKPOINT_SCALE,
	checkpoints,
	energyToX,
	ORBIT_BETA,
	orbitLabelPoints,
	PEAKS,
	project,
	SPEC_BASE_Y,
	SPEC_Z,
	STACK_BASE_Y,
	STACK_Z,
	STACKS,
} from './formations';

/** ax/ay — доля размера блока, на которую он сдвигается влево/вверх от точки. */
export type Anchor = {x: number; y: number; ax: number; ay: number};

// S3: над (-1) или под (+1) чекпоинтом — выбрано по scripts/check-layout.ts,
// чтобы плашка меньше перекрывала поток монет.
export const PATH_LABEL_SIDE = [1, 1, 1, 1];
const PATH_LABEL_GAP = 16;

export const pathLabelAnchors = (): Anchor[] =>
	checkpoints().map((p, n) => {
		const s = project(p);
		const r = 0.32 * CHECKPOINT_SCALE * s.k;
		const side = PATH_LABEL_SIDE[n];
		return {x: s.x, y: s.y + side * (r + PATH_LABEL_GAP), ax: 0.5, ay: side > 0 ? 0 : 1};
	});

// S4: под основанием стопки
export const stackLabelAnchors = (): Anchor[] =>
	STACKS.map((s) => ({...project([s.x, STACK_BASE_Y - 0.55, STACK_Z]), ax: 0.5, ay: 0}));

// S5: подписи пиков и ось энергии
export const SPEC_AXIS_Y = SPEC_BASE_Y - 0.32;
export const SPEC_TICKS = [0, 500, 1000, 1500];

export const spectrumAnchors = () => {
	const cs = project([binX(PEAKS.cs), binTopY(PEAKS.cs) + 0.3, SPEC_Z]);
	const co = project([
		(binX(PEAKS.co1) + binX(PEAKS.co2)) / 2,
		Math.max(binTopY(PEAKS.co1), binTopY(PEAKS.co2)) + 0.3,
		SPEC_Z,
	]);
	const ticks = SPEC_TICKS.map((e) => project([energyToX(e), SPEC_AXIS_Y, SPEC_Z]));
	return {
		cs: {x: cs.x, y: cs.y, ax: 0.5, ay: 1} as Anchor,
		co: {x: co.x, y: co.y, ax: 0.5, ay: 1} as Anchor,
		ticks,
		axisL: ticks[0],
		axisR: ticks[ticks.length - 1],
	};
};

// S6: подпись лежит снаружи точки — в направлении конца орбиты
export const orbitLabelAnchors = (): Anchor[] =>
	orbitLabelPoints().map((p, n) => {
		const s = project(p);
		const b = (ORBIT_BETA[n] * Math.PI) / 180;
		return {x: s.x, y: s.y, ax: 0.5 - 0.5 * Math.cos(b), ay: 0.5 + 0.5 * Math.sin(b)};
	});
