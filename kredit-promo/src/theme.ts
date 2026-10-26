import {loadFont as loadMontserrat} from '@remotion/google-fonts/Montserrat';
import {loadFont as loadPTSans} from '@remotion/google-fonts/PTSans';

export const C = {
	navy: '#0B1F3A',
	navy2: '#13294B',
	gold: '#C9A227',
	ice: '#D3DDEC',
	white: '#FFFFFF',
} as const;

const subsets = ['cyrillic', 'cyrillic-ext', 'latin', 'latin-ext'] as const;

// Заголовки: по ТЗ — Unbounded, но в его подмножествах Google Fonts нет
// казахских букв ә ғ қ ң ө ұ ү һ (cyrillic-ext содержит всего 6 глифов),
// поэтому — Montserrat (cyrillic + cyrillic-ext покрывают весь алфавит).
const display = loadMontserrat('normal', {weights: ['500', '700'], subsets: [...subsets]});
const ptSans = loadPTSans('normal', {weights: ['400', '700'], subsets: [...subsets]});

export const FONT = {
	display: `${display.fontFamily}, 'PT Sans', sans-serif`,
	text: `${ptSans.fontFamily}, 'PT Sans', sans-serif`,
};

export const TEXT_SHADOW = '0 2px 24px rgba(0,0,0,.55)';

/** Поля кадра. */
export const MARGIN = 96;
