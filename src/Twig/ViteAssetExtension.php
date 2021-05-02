<?php

namespace App\Twig;

use Psr\Cache\CacheItemPoolInterface;
use Twig\Extension\AbstractExtension;
use Twig\TwigFunction;

class ViteAssetExtension extends AbstractExtension
{

    private ?array $manifestData = null;
    const CACHE_KEY = 'vite_manifest';

    public function __construct(
        private bool $isDev,
        private string $manifest,
        private CacheItemPoolInterface $cache,
    ) {
    }

    public function getFunctions(): array
    {
        return [
            new TwigFunction('vite_asset', [$this, 'asset'], ['is_safe' => ['html']])
        ];
    }

    public function asset(string $entry, array $deps)
    {
        if ($this->isDev) {
            return $this->assetDev($entry, $deps);
        }
        return $this->assetProd($entry);
    }

    public function assetDev(string $entry, array $deps): string
    {
        $html = <<<HTML
<script type="module" src="http://localhost:3000/assets/@vite/client"></script>
HTML;
        if (in_array('react', $deps)) {
            $html .= '<script type = "module" >
                import RefreshRuntime from "http://localhost:3000/assets/@react-refresh"
    RefreshRuntime . injectIntoGlobalHook(window)
    window . $RefreshReg$ = () => {
            }
    window . $RefreshSig$ = () => (type) => type
    window . __vite_plugin_react_preamble_installed__ = true
        </script>';
        }
        $html .= <<<HTML
<script type="module" src="http://localhost:3000/assets/{$entry}" defer></script>
HTML;
        return $html;
    }

    public function assetProd(string $entry): string
    {
        if ($this->manifestData === null) {
            $item = $this->cache->getItem(self::CACHE_KEY);
            if ($item->isHit()) {
                $this->manifestData = $item->get();
            } else {
                $this->manifestData = json_decode(file_get_contents($this->manifest), true);
                $item->set($this->manifestData);
                $this->cache->save($item);
            }
        }
        $file = $this->manifestData[$entry]['file'];
        $css = $this->manifestData[$entry]['css'] ?? [];
        $imports = $this->manifestData[$entry]['imports'] ?? [];
        $html = <<<HTML
<script type="module" src="/assets/{$file}" defer></script>
HTML;
        foreach($css as $cssFile) {
            $html .= <<<HTML
<link rel="stylesheet" media="screen" href="/assets/{$cssFile}"/>
HTML;
        }

        foreach($imports as $import) {
            $html .= <<<HTML
<link rel="modulepreload" href="/assets/{$import}"/>
HTML;
        }

        return $html;
    }

}
