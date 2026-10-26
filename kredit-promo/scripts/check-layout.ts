/**
 * Проверка раскладки без рендера:
 *  1) для каждой сцены — габариты проекций всех монет (поля ≥ 64 px);
 *  2) прямоугольники подписей (размеры текста меряются в Chromium с теми же шрифтами):
 *     поля кадра, пересечения подписей друг с другом, монеты под подписями.
 *
 * Запуск: npx tsx scripts/check-layout.ts
 * Нужен playwright (глобальный) и доступ к fonts.googleapis.com.
 */
import {
	CHECKPOINT_SCALE,
	checkpoints,
	HEIGHT,
	N,
	poseAt,
	project,
	SCENES,
	SceneId,
	screenRadius,
	WIDTH,
} from '../src/world/formations';
import {
	orbitLabelAnchors,
	pathLabelAnchors,
	spectrumAnchors,
	stackLabelAnchors,
	SPEC_TICKS,
	Anchor,
} from '../src/world/layout';

// eslint-disable-next-line @typescript-eslint/no-require-imports
const {chromium} = require('playwright');

const EDGE = 64; // минимальные поля для важного
const MARGIN = 96;

type Style = {
	font: 'display' | 'text';
	weight: number;
	size: number;
	lh?: number;
	ls?: string;
	maxWidth?: number;
	plate?: boolean;
	balance?: boolean;
};
type Box = {name: string; x0: number; y0: number; x1: number; y1: number; from: number; to: number};

const display = (size: number, weight = 700): Style => ({font: 'display', weight, size, lh: 1.15, ls: '-0.01em'});
const text = (size: number, weight = 400): Style => ({font: 'text', weight, size, lh: 1.3});

async function measureAll(items: {t: string; s: Style}[]) {
	const browser = await chromium.launch(
		process.env.HTTPS_PROXY ? {proxy: {server: process.env.HTTPS_PROXY}} : {},
	);
	const page = await browser.newPage();
	await page.setContent(`<html><head>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700&family=PT+Sans:wght@400;700&display=block" rel="stylesheet">
</head><body style="margin:0"></body></html>`);
	const out = await page.evaluate(async (items: {t: string; s: Style}[]) => {
		const fam = {display: "'Montserrat'", text: "'PT Sans'"};
		const els = items.map(({t, s}) => {
			const d = document.createElement('div');
			d.textContent = t;
			Object.assign(d.style, {
				position: 'absolute',
				left: '0',
				top: '0',
				fontFamily: fam[s.font],
				fontWeight: String(s.weight),
				fontSize: s.size + 'px',
				lineHeight: String(s.lh ?? 1.2),
				letterSpacing: s.ls ?? 'normal',
				whiteSpace: s.maxWidth ? 'normal' : 'nowrap',
				maxWidth: s.maxWidth ? s.maxWidth + 'px' : '',
				textWrap: s.balance ? 'balance' : '',
				padding: s.plate ? '10px 20px' : '0',
				border: s.plate ? '1.5px solid #000' : '0',
				width: 'max-content',
			});
			document.body.appendChild(d);
			return d;
		});
		await document.fonts.ready;
		await Promise.all(
			[...document.fonts].map((f) => (f.status === 'loaded' ? null : f.load().catch(() => null))),
		);
		return els.map((e) => {
			const r = e.getBoundingClientRect();
			return {w: r.width, h: r.height};
		});
	}, items);
	const fontsOk = await page.evaluate(() =>
		[...document.fonts].filter((f) => f.status === 'loaded').map((f) => `${f.family} ${f.weight}`),
	);
	await browser.close();
	return {sizes: out as {w: number; h: number}[], fontsOk};
}

// -------------------------------------------------------------- описания подписей

type Item = {name: string; t: string; s: Style};
const items: Item[] = [];
const add = (name: string, t: string, s: Style) => {
	items.push({name, t, s});
	return name;
};

// S1
add('s1.l1', '30 академиялық сағат', display(96));
add('s1.l2', '= 1 академиялық кредит', display(64, 500));
add('s1.l3', '1 акад. сағат = 50 мин · ОКТ қағидалары, 23-т.', text(26));
// S2
add('s2.over', '«ЖОҒАРЫ МЕКТЕП ПЕДАГОГИКАСЫ» ПӘНІ', {...text(24, 700), ls: '0.12em'});
add('s2.title', 'Кредиттік жүйе негізінде жоғары мектепте оқыту үдерісін ұйымдастыру', {
	...display(72),
	lh: 1.12,
	maxWidth: 1400,
	balance: true,
});
add('s2.by', 'Адиль Алтынбек · «Ядролық физика», магистратура 1-курс · 2026', text(28));
// S3
add('s3.h', 'Студент — өз траекториясының авторы', display(56));
add('s3.sub', 'эдвайзердің көмегімен', text(28));
const PATH_LABELS = ['Элективтер каталогы', 'Жеке оқу жоспары', 'Пәнге тіркелу', 'Оқу нәтижесі'];
PATH_LABELS.forEach((t, n) => add(`s3.cp${n}`, t, {...text(30, 700), plate: true}));
// S4
add('s4.h', 'Жүктеме кредитпен өлшенеді', display(56));
add('s4.ects', 'ECTS: 1 кредит ≈ 25–30 сағат', text(24));
const STACK_LABELS = [
	['1 кредит', '30 акад. сағат'],
	['60 кредит', 'толық оқу жылы'],
	['≥ 120 кредит', 'ғылыми-педагогикалық магистратура'],
];
STACK_LABELS.forEach(([a, b], n) => {
	add(`s4.st${n}a`, a, display(40));
	add(`s4.st${n}b`, b, text(24));
});
// S5
add('s5.h', 'Ядролық физикадағы мысал', display(56));
add('s5.cs', 'Cs-137 · 661,7 кэВ', text(28, 700));
add('s5.co', 'Co-60 · 1173,2 / 1332,5 кэВ', text(28, 700));
SPEC_TICKS.forEach((e) => add(`s5.t${e}`, String(e), text(22)));
add('s5.axis', 'Энергия, кэВ', text(24, 700));
add('s5.schem', 'схемалық спектр', text(22));
const PLATES = ['Зертхана: калибрлеу', 'Есептеу: Монте-Карло', 'Жоба: зерттеу сұрағы'];
PLATES.forEach((t, n) => add(`s5.p${n}`, t, {...text(26, 700), plate: true}));
// S6
add('s6.h', 'Сындарлы сәйкестендіру', {...text(26, 700), ls: '0.04em'});
const ORBIT_LABELS = ['Оқу нәтижесі', 'Оқу әрекеті', 'Бағалау'];
ORBIT_LABELS.forEach((t, n) => add(`s6.o${n}`, t, display(36, 500)));
add('s6.bottom', 'Кредит оқу нәтижесі расталғанда ғана беріледі', text(34, 700));
// S7
add('s7.l1', 'Кредит — сағат емес.', display(84));
add('s7.l2', 'Расталған оқу нәтижесі.', display(84));
add('s7.l3', 'Жоғары мектеп педагогикасы · 2026', text(28));

// -------------------------------------------------------------- раскладка

function layout(size: Record<string, {w: number; h: number}>) {
	const boxes: Record<SceneId, Box[]> = {
		hook: [],
		title: [],
		path: [],
		stacks: [],
		spectrum: [],
		orbits: [],
		outro: [],
	};
	const scene = (id: SceneId) => SCENES.find((s) => s.id === id)!;
	const put = (id: SceneId, name: string, x0: number, y0: number, delay = 0) => {
		const s = scene(id);
		const {w, h} = size[name];
		boxes[id].push({name, x0, y0, x1: x0 + w, y1: y0 + h, from: s.from + delay + 8, to: s.to - 12});
	};
	const at = (id: SceneId, name: string, a: Anchor, delay = 0) => {
		const {w, h} = size[name];
		put(id, name, a.x - a.ax * w, a.y - a.ay * h, delay);
	};
	const centerCol = (id: SceneId, names: [string, number][], top: number, delays: number[]) => {
		let y = top;
		names.forEach(([n, mt], k) => {
			y += mt;
			put(id, n, WIDTH / 2 - size[n].w / 2, y, delays[k]);
			y += size[n].h;
		});
	};
	const colHeight = (names: [string, number][]) =>
		names.reduce((acc, [n, mt]) => acc + mt + size[n].h, 0);

	// S1 — нижняя треть
	const s1: [string, number][] = [
		['s1.l1', 0],
		['s1.l2', 6],
		['s1.l3', 18],
	];
	centerCol('hook', s1, HEIGHT - MARGIN - colHeight(s1), [10, 55, 70]);
	// S2 — по центру
	const s2: [string, number][] = [
		['s2.over', 0],
		['s2.title', 22],
		['s2.by', 26],
	];
	centerCol('title', s2, HEIGHT / 2 - colHeight(s2) / 2, [10, 16, 28]);
	// S3
	put('path', 's3.h', MARGIN, MARGIN, 8);
	put('path', 's3.sub', MARGIN, MARGIN + size['s3.h'].h + 10, 16);
	pathLabelAnchors().forEach((a, n) => at('path', `s3.cp${n}`, a, 30 + n * 12));
	// S4
	put('stacks', 's4.h', MARGIN, MARGIN, 8);
	put('stacks', 's4.ects', WIDTH - MARGIN - size['s4.ects'].w, MARGIN, 20);
	stackLabelAnchors().forEach((a, n) => {
		const A = size[`s4.st${n}a`];
		const B = size[`s4.st${n}b`];
		put('stacks', `s4.st${n}a`, a.x - A.w / 2, a.y, 10);
		put('stacks', `s4.st${n}b`, a.x - B.w / 2, a.y + A.h + 4, 10);
	});
	// S5
	put('spectrum', 's5.h', MARGIN, MARGIN, 8);
	const sp = spectrumAnchors();
	at('spectrum', 's5.cs', sp.cs, 30);
	at('spectrum', 's5.co', sp.co, 36);
	sp.ticks.forEach((t, n) => at('spectrum', `s5.t${SPEC_TICKS[n]}`, {x: t.x, y: t.y + 14, ax: 0.5, ay: 0}, 18));
	at('spectrum', 's5.axis', {x: (sp.ticks[2].x + sp.ticks[3].x) / 2, y: sp.ticks[2].y + 14, ax: 0.5, ay: 0}, 18);
	at('spectrum', 's5.schem', {x: (sp.ticks[0].x + sp.ticks[1].x) / 2, y: sp.ticks[0].y + 14, ax: 0.5, ay: 0}, 18);
	const pw = PLATES.reduce((a, _, n) => a + size[`s5.p${n}`].w, 0) + 28 * (PLATES.length - 1);
	let px = WIDTH / 2 - pw / 2;
	PLATES.forEach((_, n) => {
		const s = size[`s5.p${n}`];
		put('spectrum', `s5.p${n}`, px, HEIGHT - MARGIN - s.h, 48 + n * 8);
		px += s.w + 28;
	});
	// S6
	put('orbits', 's6.h', MARGIN, MARGIN, 8);
	orbitLabelAnchors().forEach((a, n) => at('orbits', `s6.o${n}`, a, 22 + n * 10));
	put('orbits', 's6.bottom', WIDTH / 2 - size['s6.bottom'].w / 2, HEIGHT - MARGIN - size['s6.bottom'].h, 56);
	// S7
	const s7: [string, number][] = [
		['s7.l1', 0],
		['s7.l2', 8],
		['s7.l3', 30],
	];
	centerCol('outro', s7, HEIGHT / 2 - colHeight(s7) / 2, [8, 26, 48]);
	return boxes;
}

// -------------------------------------------------------------- проверки

const overlap = (a: Box, b: Box) => a.x0 < b.x1 && b.x0 < a.x1 && a.y0 < b.y1 && b.y0 < a.y1;
const discHitsBox = (cx: number, cy: number, r: number, b: Box, pad = 0) => {
	const nx = Math.max(b.x0 - pad, Math.min(cx, b.x1 + pad));
	const ny = Math.max(b.y0 - pad, Math.min(cy, b.y1 + pad));
	return (cx - nx) ** 2 + (cy - ny) ** 2 < r * r;
};
const f1 = (v: number) => v.toFixed(0).padStart(5);

(async () => {
	const {sizes, fontsOk} = await measureAll(items);
	console.log('Шрифты загружены:', [...new Set(fontsOk)].join(', ') || 'НЕТ (размеры приблизительные!)');
	const size: Record<string, {w: number; h: number}> = {};
	items.forEach((it, k) => (size[it.name] = sizes[k]));
	const boxes = layout(size);
	let problems = 0;

	console.log('\n== Монеты: габариты проекций (после перестроения, до следующего) ==');
	for (const s of SCENES) {
		// формация «устоялась»: от начала сцены + 26 (для стопок +70) до конца сцены − 10
		const settle = s.id === 'hook' ? 50 : s.id === 'stacks' ? 60 : 26;
		let x0 = Infinity, y0 = Infinity, x1 = -Infinity, y1 = -Infinity;
		const coinHits: Record<string, number> = {};
		for (let f = s.from + settle; f < s.to - 10; f += 2) {
			for (let i = 0; i < N; i++) {
				const pose = poseAt(i, f);
				const r = screenRadius(pose);
				if (r < 1) continue;
				const c = project(pose.p);
				x0 = Math.min(x0, c.x - r); x1 = Math.max(x1, c.x + r);
				y0 = Math.min(y0, c.y - r); y1 = Math.max(y1, c.y + r);
				for (const b of boxes[s.id]) {
					if (f < b.from || f > b.to) continue;
					if (discHitsBox(c.x, c.y, r * 0.85, b)) coinHits[b.name] = (coinHits[b.name] ?? 0) + 1;
				}
			}
		}
		const inFrame = x0 >= EDGE && y0 >= EDGE && x1 <= WIDTH - EDGE && y1 <= HEIGHT - EDGE;
		const decorative = s.id === 'outro'; // кольца финала намеренно уходят за кадр
		console.log(
			`${s.id.padEnd(9)} x:[${f1(x0)},${f1(x1)}] y:[${f1(y0)},${f1(y1)}] ${inFrame ? 'OK' : decorative ? 'за кадром (декоративные кольца)' : 'ВЫХОДИТ ЗА ПОЛЯ'}`,
		);
		if (!inFrame && !decorative) problems++;
		const hits = Object.entries(coinHits);
		if (hits.length)
			console.log('          монеты под подписями (монето-кадров):', hits.map(([k, v]) => `${k}=${v}`).join(' '));
	}

	console.log('\n== Подписи ==');
	for (const s of SCENES) {
		for (const b of boxes[s.id]) {
			const ok = b.x0 >= EDGE && b.y0 >= EDGE && b.x1 <= WIDTH - EDGE && b.y1 <= HEIGHT - EDGE;
			const ok96 = b.x0 >= MARGIN - 0.5 && b.y0 >= MARGIN - 0.5 && b.x1 <= WIDTH - MARGIN + 0.5 && b.y1 <= HEIGHT - MARGIN + 0.5;
			console.log(
				`${b.name.padEnd(12)} [${f1(b.x0)},${f1(b.y0)} → ${f1(b.x1)},${f1(b.y1)}] ${ok ? (ok96 ? 'OK' : 'OK (поля 64–96)') : 'ЗА ПОЛЯМИ'}`,
			);
			if (!ok) problems++;
		}
		const bs = boxes[s.id];
		for (let a = 0; a < bs.length; a++)
			for (let c = a + 1; c < bs.length; c++)
				if (overlap(bs[a], bs[c])) {
					console.log(`  ПЕРЕСЕЧЕНИЕ: ${bs[a].name} × ${bs[c].name}`);
					problems++;
				}
	}

	// S3: какую сторону выбрать для плашек чекпоинтов
	console.log('\n== S3: монето-кадров потока под плашкой — над / под чекпоинтом ==');
	const path = SCENES.find((s) => s.id === 'path')!;
	checkpoints().forEach((p, n) => {
		const c = project(p);
		const r = 0.32 * CHECKPOINT_SCALE * c.k;
		const {w, h} = size[`s3.cp${n}`];
		const count = (side: number) => {
			const y0 = side > 0 ? c.y + r + 16 : c.y - r - 16 - h;
			const b: Box = {name: '', x0: c.x - w / 2, x1: c.x + w / 2, y0, y1: y0 + h, from: 0, to: 0};
			let hits = 0;
			for (let f = path.from + 26; f < path.to; f += 2)
				for (let i = 4; i < N; i++) {
					const pose = poseAt(i, f);
					const q = project(pose.p);
					if (discHitsBox(q.x, q.y, screenRadius(pose) * 0.85, b)) hits++;
				}
			return hits;
		};
		const up = count(-1);
		const down = count(1);
		console.log(`  ${PATH_LABELS[n].padEnd(22)} над: ${String(up).padStart(4)}  под: ${String(down).padStart(4)}  → ${up <= down ? 'над (-1)' : 'под (+1)'}`);
	});
	console.log(problems ? `\nПроблем: ${problems}` : '\nПроблем не найдено');
	process.exit(problems ? 1 : 0);
})();
