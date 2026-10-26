import type {CSSProperties} from 'react';
import {C, FONT, TEXT_SHADOW} from '../theme';
import {useReveal} from './reveal';

type Props = {
	delay?: number;
	style?: CSSProperties;
	children: React.ReactNode;
};

const base: CSSProperties = {
	color: C.white,
	textShadow: TEXT_SHADOW,
	margin: 0,
	whiteSpace: 'pre-wrap',
};

/** Строка с появлением пружиной. */
export const Reveal: React.FC<Props> = ({delay = 0, style, children}) => {
	const r = useReveal(delay);
	return <div style={{...base, ...style, ...r}}>{children}</div>;
};

export const display = (size: number, weight: 500 | 700 = 700): CSSProperties => ({
	fontFamily: FONT.display,
	fontWeight: weight,
	fontSize: size,
	lineHeight: 1.15,
	letterSpacing: '-0.01em',
});

export const text = (size: number, weight: 400 | 700 = 400): CSSProperties => ({
	fontFamily: FONT.text,
	fontWeight: weight,
	fontSize: size,
	lineHeight: 1.3,
});

/** Плашка navy2 с золотой обводкой. */
export const plate: CSSProperties = {
	background: 'rgba(19, 41, 75, 0.94)',
	border: `1.5px solid ${C.gold}`,
	borderRadius: 10,
	padding: '10px 20px',
	whiteSpace: 'nowrap',
	textShadow: 'none',
};
