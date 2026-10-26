import {AbsoluteFill} from 'remotion';
import {C} from '../theme';
import {Reveal, display, text} from '../ui/Text';

export const Title: React.FC = () => (
	<AbsoluteFill style={{justifyContent: 'center', alignItems: 'center', textAlign: 'center'}}>
		<Reveal
			delay={10}
			style={{...text(24, 700), color: C.gold, letterSpacing: '0.12em', marginBottom: 22}}
		>
			«ЖОҒАРЫ МЕКТЕП ПЕДАГОГИКАСЫ» ПӘНІ
		</Reveal>
		<Reveal
			delay={16}
			style={{...display(72), maxWidth: 1400, textWrap: 'balance', lineHeight: 1.12}}
		>
			Кредиттік жүйе негізінде жоғары мектепте оқыту үдерісін ұйымдастыру
		</Reveal>
		<Reveal delay={28} style={{...text(28), color: C.ice, marginTop: 26}}>
			Адиль Алтынбек · «Ядролық физика», магистратура 1-курс · 2026
		</Reveal>
	</AbsoluteFill>
);
