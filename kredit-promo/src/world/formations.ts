// Чистые функции: таймлайн, позы монет, проекция 3D → экран.
// Никакого React / three здесь нет — модуль используется и сценой, и оверлеями,
// и проверочным скриптом на Node.

export type Vec3 = [number, number, number];
export type Pose = {p: Vec3; r: Vec3; s: Vec3};

export const N = 181;
export const FPS = 30;
export const DURATION = 900;
export const WIDTH = 1920;
export const HEIGHT = 1080;

// ---------------------------------------------------------------- таймлайн

export type SceneId =
	| 'hook'
	| 'title'
	| 'path'
	| 'stacks'
	| 'spectrum'
	| 'orbits'
	| 'outro';

export const SCENES: {id: SceneId; from: number; to: number}[] = [
	{id: 'hook', from: 0, to: 120},
	{id: 'title', from: 120, to: 255},
	{id: 'path', from: 255, to: 405},
	{id: 'stacks', from: 405, to: 555},
	{id: 'spectrum', from: 555, to: 675},
	{id: 'orbits', from: 675, to: 795},
	{id: 'outro', from: 795, to: 900},
];

export const BOUNDS = SCENES.slice(1).map((s) => s.from); // 120 255 405 555 675 795

// ---------------------------------------------------------------- камера

export const CAMERA_Z = 16;
export const FOV = 40;
const TAN_HALF = Math.tan(((FOV / 2) * Math.PI) / 180);

/** Пикселей на единицу мира на глубине z. */
export const pxPerUnit = (z: number) => HEIGHT / 2 / ((CAMERA_Z - z) * TAN_HALF);

export const project = ([x, y, z]: Vec3) => {
	const k = pxPerUnit(z);
	return {x: WIDTH / 2 + x * k, y: HEIGHT / 2 - y * k, k};
};

// ---------------------------------------------------------------- случайности

export function mulberry32(seed: number) {
	let a = seed >>> 0;
	return () => {
		a = (a + 0x6d2b79f5) >>> 0;
		let t = a;
		t = Math.imul(t ^ (t >>> 15), t | 1);
		t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
		return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
	};
}

const rng = mulberry32(42);
const table = () => Array.from({length: N}, () => rng());
const R = {
	x: table(),
	y: table(),
	z: table(),
	rx: table(),
	ry: table(),
	rz: table(),
	drop: table(),
	delay: table(),
	jx: table(),
	jy: table(),
	jz: table(),
	spin: table(),
};

// ---------------------------------------------------------------- утилиты

const TAU = Math.PI * 2;
const FACE = Math.PI / 2; // rotation.x, при котором монета смотрит в камеру

const lerp = (a: number, b: number, t: number) => a + (b - a) * t;
const clamp01 = (t: number) => Math.min(1, Math.max(0, t));
export const easeInOutCubic = (t: number) =>
	t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;

const uni = (s: number): Vec3 => [s, s, s];
const facing = (p: Vec3, s: number | Vec3 = 1, ry = 0): Pose => ({
	p,
	r: [FACE, ry, 0],
	s: typeof s === 'number' ? uni(s) : s,
});

// ---------------------------------------------------------------- F0 россыпь

const F0 = (i: number): Pose => ({
	p: [lerp(-13, 13, R.x[i]), lerp(10, 18, R.y[i]), lerp(-8, 0, R.z[i])],
	r: [R.rx[i] * TAU, R.ry[i] * TAU, R.rz[i] * TAU],
	s: uni(1),
});

// ---------------------------------------------------------------- F1 «30 → 1»

export const F1_CENTER_Y = 1.3;
export const F1_RING_R = 3.4;
export const F1_RING_Z = -3;
// По ТЗ стена на z = -14 вокруг y = 1.3, но тогда её нижние ряды стоят прямо
// под текстом нижней трети. Стена отодвинута глубже в туман и поднята так,
// чтобы целиком помещаться между верхним полем и текстом.
const F1_WALL_Z = -18;
const F1_WALL_Y = 3.1;

const F1 = (i: number, f: number): Pose => {
	if (i === 0) {
		return {
			p: [0, F1_CENTER_Y, 1],
			r: [FACE, 0.15 * Math.sin(f / 30), 0],
			s: [3.2, 2.0, 3.2],
		};
	}
	if (i <= 30) {
		const a = ((i - 1) / 30) * TAU + 0.006 * f;
		return facing(
			[F1_RING_R * Math.cos(a), F1_CENTER_Y + F1_RING_R * Math.sin(a), F1_RING_Z],
			1.1,
		);
	}
	const j = i - 31;
	const col = j % 15;
	const row = Math.floor(j / 15);
	return facing(
		[(col - 7) * 1.6, F1_WALL_Y + (row - 4.5) * 1.6, F1_WALL_Z],
		1.3,
	);
};

// ---------------------------------------------------------------- F2 кольцо

const F2_RX = 9.3;
const F2_RY = 4.4;
const F2_Z = -1.5;

const F2 = (i: number, f: number): Pose => {
	const a = (i / N) * TAU + f * 0.004;
	return facing(
		[F2_RX * Math.cos(a), F2_RY * Math.sin(a), F2_Z],
		1,
		0.6 * Math.sin(a + f * 0.03),
	);
};

// ---------------------------------------------------------------- F3 траектория

const PATH: Vec3[] = [
	[-9, -3, 0],
	[-4, 2, -1],
	[1, -1.5, 0],
	[5, 2.5, -1],
	[9, 0, 0],
];

/** Равномерный Catmull-Rom через PATH, u ∈ [0, 1]. Концы продлены зеркально. */
export function pathPoint(u: number): Vec3 {
	const n = PATH.length - 1;
	const x = clamp01(u) * n;
	const seg = Math.min(n - 1, Math.floor(x));
	const t = x - seg;
	const at = (k: number): Vec3 => {
		if (k < 0) return PATH[0].map((v, d) => 2 * v - PATH[1][d]) as Vec3;
		if (k > n) return PATH[n].map((v, d) => 2 * v - PATH[n - 1][d]) as Vec3;
		return PATH[k];
	};
	const p0 = at(seg - 1);
	const p1 = at(seg);
	const p2 = at(seg + 1);
	const p3 = at(seg + 2);
	const t2 = t * t;
	const t3 = t2 * t;
	return [0, 1, 2].map(
		(d) =>
			0.5 *
			(2 * p1[d] +
				(-p0[d] + p2[d]) * t +
				(2 * p0[d] - 5 * p1[d] + 4 * p2[d] - p3[d]) * t2 +
				(-p0[d] + 3 * p1[d] - 3 * p2[d] + p3[d]) * t3),
	) as Vec3;
}

export const CHECKPOINT_U = [0.08, 0.36, 0.64, 0.92];
export const CHECKPOINT_SCALE = 2.4;
export const checkpoints = (): Vec3[] => CHECKPOINT_U.map(pathPoint);

const F3 = (i: number, f: number): Pose => {
	if (i < 4) return facing(pathPoint(CHECKPOINT_U[i]), CHECKPOINT_SCALE);
	const u = (((i / N + f * 0.0016) % 1) + 1) % 1;
	const c = pathPoint(u);
	// у концов кривой монета плавно сжимается — без «скачка» при u: 1 → 0
	const edge = Math.min(1, u / 0.04, (1 - u) / 0.04);
	const sp = 0.25;
	return facing(
		[c[0] + (R.jx[i] * 2 - 1) * sp, c[1] + (R.jy[i] * 2 - 1) * sp, c[2] + (R.jz[i] * 2 - 1) * sp],
		0.8 * Math.max(0.001, edge),
		0.5 * Math.sin(u * TAU * 3 + R.spin[i] * TAU),
	);
};

// ---------------------------------------------------------------- F4 три стопки

export const STACK_BASE_Y = -4.0;
export const STACK_Z = -3;
export const STACK_STEP = 0.072;
export const STACKS = [
	{x: -6.2, first: 0, count: 1},
	{x: 0, first: 1, count: 60},
	{x: 6.2, first: 61, count: 120},
];

const stackOf = (i: number) => {
	const s = i === 0 ? 0 : i <= 60 ? 1 : 2;
	return {s, k: i - STACKS[s].first};
};

const F4 = (i: number): Pose => {
	const {s, k} = stackOf(i);
	return {
		p: [STACKS[s].x, STACK_BASE_Y + k * STACK_STEP, STACK_Z],
		r: [0.32, 0, 0],
		s: [1.7, 1, 1.7],
	};
};

/** Кадр (от начала перехода в F4), к которому стопка s полностью выросла. */
export const stackGrownAt = (s: number) => (STACKS[s].count - 1) * 0.35 + 24;

// ---------------------------------------------------------------- F5 гамма-спектр

const E_MAX = 1500;
export const BINS = 36;
const BIN_W = E_MAX / BINS;
export const SPEC_X0 = -9;
export const SPEC_X1 = 9;
export const SPEC_BASE_Y = -3.2;
export const SPEC_STEP = 0.15;
export const SPEC_Z = 0;

export const energyToX = (e: number) => SPEC_X0 + ((SPEC_X1 - SPEC_X0) * e) / E_MAX;

const gauss = (e: number, mu: number, sigma: number) =>
	Math.exp(-0.5 * ((e - mu) / sigma) ** 2);
const below = (e: number, edge: number, soft: number) => 1 / (1 + Math.exp((e - edge) / soft));

/** Схематичный спектр NaI(Tl): Cs-137 + Co-60 с комптоновскими пьедесталами. */
const spectrumDensity = (e: number) =>
	1.0 * gauss(e, 661.7, 22) +
	0.12 * below(e, 477, 12) +
	0.55 * gauss(e, 1173.2, 29) +
	0.5 * gauss(e, 1332.5, 31) +
	0.08 * below(e, 1040, 14);

const binWeights = Array.from({length: BINS}, (_, j) => {
	// среднее по бину (число отсчётов в бине)
	let acc = 0;
	const steps = 24;
	for (let s = 0; s < steps; s++) acc += spectrumDensity((j + (s + 0.5) / steps) * BIN_W);
	return acc / steps;
});

/** Метод наибольших остатков: ровно N монет по бинам. */
export const binCounts: number[] = (() => {
	const total = binWeights.reduce((a, b) => a + b, 0);
	const exact = binWeights.map((w) => (w / total) * N);
	const counts = exact.map(Math.floor);
	let left = N - counts.reduce((a, b) => a + b, 0);
	const order = exact
		.map((v, j) => ({j, rem: v - Math.floor(v)}))
		.sort((a, b) => b.rem - a.rem || a.j - b.j);
	for (let q = 0; left > 0; q++, left--) counts[order[q].j]++;
	return counts;
})();

export const binX = (j: number) => energyToX((j + 0.5) * BIN_W);
export const binTopY = (j: number) => SPEC_BASE_Y + (binCounts[j] - 1) * SPEC_STEP;
const binOfEnergy = (e: number) => Math.min(BINS - 1, Math.floor(e / BIN_W));
const peakBin = (e: number) => {
	// самый высокий бин в окрестности линии
	const c = binOfEnergy(e);
	return [c - 1, c, c + 1].reduce((a, b) => (binCounts[b] > binCounts[a] ? b : a));
};

export const PEAKS = {
	cs: peakBin(661.7),
	co1: peakBin(1173.2),
	co2: peakBin(1332.5),
};

const coinBin: {j: number; k: number}[] = (() => {
	const out: {j: number; k: number}[] = [];
	binCounts.forEach((c, j) => {
		for (let k = 0; k < c; k++) out.push({j, k});
	});
	return out;
})();

const F5 = (i: number): Pose => {
	const {j, k} = coinBin[i];
	return {
		p: [binX(j), SPEC_BASE_Y + k * SPEC_STEP, SPEC_Z],
		r: [0.25, 0, 0],
		s: [0.7, 1.8, 0.7],
	};
};

// ---------------------------------------------------------------- F6 три орбиты

export const ORBIT_CENTER: Vec3 = [0, -0.6, -4];
export const ORBIT_R = 4.3;
const ORBIT_TILT = (72 * Math.PI) / 180;
export const ORBIT_BETA = [90, 210, 330];

const orbitPoint = (o: number, phi: number): Vec3 => {
	const x = ORBIT_R * Math.cos(phi);
	const y0 = ORBIT_R * Math.sin(phi);
	const y = y0 * Math.cos(ORBIT_TILT);
	const z = y0 * Math.sin(ORBIT_TILT);
	const b = (ORBIT_BETA[o] * Math.PI) / 180;
	return [
		ORBIT_CENTER[0] + x * Math.cos(b) - y * Math.sin(b),
		ORBIT_CENTER[1] + x * Math.sin(b) + y * Math.cos(b),
		ORBIT_CENTER[2] + z,
	];
};

/** Точки подписей — на продолжении «концов» орбит. */
export const orbitLabelPoints = (): Vec3[] =>
	ORBIT_BETA.map((deg) => {
		const b = (deg * Math.PI) / 180;
		const r = ORBIT_R + 0.9;
		return [ORBIT_CENTER[0] + r * Math.cos(b), ORBIT_CENTER[1] + r * Math.sin(b), ORBIT_CENTER[2]];
	});

const F6 = (i: number, f: number): Pose => {
	if (i === 0) return facing(ORBIT_CENTER, 2.6, f * 0.035);
	const o = (i - 1) % 3;
	const slot = Math.floor((i - 1) / 3);
	const dir = o === 1 ? -1 : 1;
	const phi = (slot / 60) * TAU + dir * 0.012 * f;
	return facing(orbitPoint(o, phi), 0.75);
};

// ---------------------------------------------------------------- F7 финал

const RINGS = [
	{count: 50, r: 6.4},
	{count: 60, r: 7.4},
	{count: 70, r: 8.4},
];
// По ТЗ z = -5, но тогда внутреннее кольцо (R 6.4 → 452 px) режет строки 84 px
// (ширина до 1100 px). На z = 1 кольца обрамляют текст слева и справа.
export const OUTRO_Z = 1;

const F7 = (i: number, f: number): Pose => {
	if (i === 0) return facing([0, 0, OUTRO_Z], 0.001);
	let j = i - 1;
	let ring = 0;
	while (j >= RINGS[ring].count) j -= RINGS[ring++].count;
	const {count, r} = RINGS[ring];
	const dir = ring % 2 === 0 ? 1 : -1;
	const a = (j / count) * TAU + dir * 0.004 * f + ring * 0.3;
	return facing([r * Math.cos(a), r * Math.sin(a), OUTRO_Z], 1);
};

// ---------------------------------------------------------------- морфинг

const FORMS: ((i: number, f: number) => Pose)[] = [F0, F1, F2, F3, F4, F5, F6, F7];

type Transition = {to: number; start: number; dur: number; delay: (i: number) => number};

const TRANSITIONS: Transition[] = [
	{to: 1, start: 0, dur: 30, delay: (i) => R.drop[i] * 20},
	...BOUNDS.map(
		(b, k): Transition => ({
			to: k + 2,
			start: b - 10,
			dur: 24,
			delay: k + 2 === 4 ? (i) => stackOf(i).k * 0.35 : (i) => R.delay[i] * 12,
		}),
	),
];

/** Кадр, с которого начинается переход в формацию `to` (для синхронизации подписей). */
export const transitionStart = (to: number) => TRANSITIONS.find((t) => t.to === to)!.start;

const lerp3 = (a: Vec3, b: Vec3, t: number): Vec3 => [
	lerp(a[0], b[0], t),
	lerp(a[1], b[1], t),
	lerp(a[2], b[2], t),
];

export function poseAt(i: number, f: number): Pose {
	let k = 0;
	while (k + 1 < TRANSITIONS.length && TRANSITIONS[k + 1].start <= f) k++;
	const tr = TRANSITIONS[k];
	const t = easeInOutCubic(clamp01((f - tr.start - tr.delay(i)) / tr.dur));
	const to = FORMS[tr.to](i, f);
	if (t >= 1) return to;
	const from = FORMS[tr.to - 1](i, f);
	if (t <= 0) return from;
	return {p: lerp3(from.p, to.p, t), r: lerp3(from.r, to.r, t), s: lerp3(from.s, to.s, t)};
}

/** Экранный радиус монеты (верхняя оценка — по диаметру торца). */
export const screenRadius = (pose: Pose) =>
	0.32 * Math.max(pose.s[0], pose.s[2]) * pxPerUnit(pose.p[2]);
