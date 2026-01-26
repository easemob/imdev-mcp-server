import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export type EntryRouteSurface = 'appearance' | 'options' | 'component_props' | 'theme_tokens' | 'override' | 'source';

export type EntryRoute = {
  surface: EntryRouteSurface;
  summary?: string;
  docPath?: string;
  sourcePath?: string;
  examples?: string[];
};

export type PlatformCapability = {
  status: 'available' | 'planned';
  entryRoutes: EntryRoute[];
  sourceEntrypoints?: string[];
  note?: string;
};

export type ModuleCapability = {
  displayName: string;
  aliases: string[];
  defaultPlatform?: string;
  platforms: Record<string, PlatformCapability>;
};

type PlatformIndex = {
  version: string;
  lastUpdated: string;
  modules: Record<string, ModuleCapability>;
};

export type PlatformRoute = {
  moduleId: string;
  moduleName: string;
  platform: string;
  status: PlatformCapability['status'];
  entryRoutes: EntryRoute[];
  sourceEntrypoints?: string[];
  note?: string;
};

export class PlatformCapabilityRegistry {
  private dataDir: string;
  private index: PlatformIndex | null = null;

  constructor(dataDir?: string) {
    this.dataDir = dataDir || path.join(__dirname, '../../data/platforms');
  }

  getModule(moduleId: string): ModuleCapability | null {
    const index = this.load();
    return index.modules[moduleId] || null;
  }

  getModuleByAlias(alias: string): { id: string; module: ModuleCapability } | null {
    const index = this.load();
    const normalized = alias.toLowerCase();
    for (const [id, module] of Object.entries(index.modules)) {
      if (module.aliases.some(a => a.toLowerCase() === normalized)) {
        return { id, module };
      }
    }
    return null;
  }

  getPlatformRoute(moduleId: string, platform: string): PlatformRoute | null {
    const module = this.getModule(moduleId);
    if (!module) return null;

    const normalizedPlatform = platform.toLowerCase();
    const capability = module.platforms[normalizedPlatform];
    if (!capability) return null;

    return {
      moduleId,
      moduleName: module.displayName,
      platform: normalizedPlatform,
      status: capability.status,
      entryRoutes: capability.entryRoutes || [],
      sourceEntrypoints: capability.sourceEntrypoints,
      note: capability.note
    };
  }

  private load(): PlatformIndex {
    if (this.index) return this.index;

    const indexPath = path.join(this.dataDir, 'index.json');
    if (!fs.existsSync(indexPath)) {
      throw new Error(`Platform capability index not found: ${indexPath}`);
    }

    this.index = JSON.parse(fs.readFileSync(indexPath, 'utf-8')) as PlatformIndex;
    return this.index;
  }
}
